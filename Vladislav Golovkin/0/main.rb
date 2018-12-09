require 'roo'
require 'spreadsheet'

FIRST_SHEET = 0
NAME_COL = 0
AREA_COL = 6
DATE_ROW = 3
TABLE_HEADER = 8
DENOM_BYN = 10_000
DENOM_YEAR = 2017
DELTA = 0.2
DATA_FOLDER = './data/'.freeze

# product properties
class ProductData
  attr_accessor :date, :price

  def initialize(price = 0, date = Date.new)
    @price = price
    @date = date
  end
end

# collection of products
class ProductsAnalyzer
  attr_accessor :latest_date

  def initialize(dictionary = Hash.new([]), latest_date = Date.new)
    @dictionary = dictionary
    @latest_date = latest_date

    @months = { 'январь' => 1, 'февраль' => 2, 'март' => 3, 'апрель' => 4,
                'май' => 5, 'июнь' => 6, 'июль' => 7, 'август' => 8,
                'сентябрь' => 9, 'октябрь' => 10, 'ноябрь' => 11,
                'декабрь' => 12 }
  end

  def get_date(string)
    values = string.to_s.chomp.split(' ')

    year = nil
    month = nil

    values.each do |token|
      month = @months[token] if @months.include? token.downcase
      year = token.to_i if token =~ /^[-+]?[1-9]([0-9]*)?$/
    end

    # use 1st day of month for initializing
    date = Date.new(year, month, 1)
    @latest_date = date if latest_date < date
    date
  end

  def add_entry(product_name, date_str, price)
    date = get_date(date_str)
    new_entry = ProductData.new(price, date)

    new_entry.price /= DENOM_BYN if date.year < DENOM_YEAR

    product_name = product_name.to_s.squeeze(' ')
    reg_exp = /^[\dA-Z_]+$/
    product_name = product_name.gsub(reg_exp, '')
    @dictionary[product_name] = [] unless @dictionary.key?(product_name)
    @dictionary[product_name] << new_entry
  end

  def get_similar(latest_product)
    @dictionary.each_with_object([]) do |(name, products), result|
      products.each do |product|
        price = latest_product.price
        next unless product.date == latest_date &&
                    product.price.between?(price - DELTA, price + DELTA)

        result << "#{name.capitalize} with price #{product.price} BYN"
      end
    end
  end

  def process_request(input)
    processed = false
    @dictionary.each do |product_name, products|
      next unless product_name.downcase.split(/[\s,]+/).include? input.downcase

      latest_product = get_latest_product(products)
      next unless latest_product

      processed = true
      print_request(product_name, latest_product, products.min_by(&:price),
                    products.max_by(&:price), get_similar(latest_product))
    end
    puts 'Nothing found.' unless processed
  end

  def get_latest_product(products)
    latest_product = nil
    products.each do |product|
      next unless product.date.year == latest_date.year &&
                  product.date.month == latest_date.month

      latest_product = product
      break
    end
    latest_product
  end

  def print_latest(product_name, latest_product)
    puts "#{product_name.capitalize} is "\
      "#{latest_product.price.round(2)} BYN these days"
  end

  def print_min(min_product)
    puts 'Lowest was on '\
      "#{min_product.date.year}/#{min_product.date.month}"\
      " at price #{min_product.price.round(2)} BYN"
  end

  def print_max(max_product)
    puts 'Highest was on '\
      "#{max_product.date.year}/#{max_product.date.month}"\
      " at price #{max_product.price.round(2)} BYN"
  end

  def print_same_price(products)
    puts "For the same price (+/- #{DELTA} BYN) you can get: "
    puts products
  end

  def print_request(key, latest_product, min_product, max_product, products)
    puts '=' * 80
    print_latest(key, latest_product)
    print_min(min_product)
    print_max(max_product)
    print_same_price(products)
  end
end

# use this to run application
class Application
  def initialize(analyzer = ProductsAnalyzer.new,
                 files = Dir.entries(DATA_FOLDER))
    @analyzer = analyzer
    @files = files
    collect_data
  end

  def collect_data
    puts 'Collecting data...'

    @files.each do |file|
      if File.extname(file) == '.xlsx'
        collect_xlsx(file)
      elsif File.extname(file) == '.xls'
        collect_xls(file)
      end
    end
  end

  def collect_xls(file)
    xls = Spreadsheet.open "#{DATA_FOLDER}#{file}"
    sheet = xls.worksheet(FIRST_SHEET)
    # zero indexing
    date = sheet.row(DATE_ROW - 1)

    sheet.drop(TABLE_HEADER).each do |row|
      @analyzer.add_entry(row[NAME_COL], date, row[AREA_COL]) if row[AREA_COL]
    end
  end

  def collect_xlsx(file)
    xlsx = Roo::Spreadsheet.open("#{DATA_FOLDER}#{file}")
    sheet = xlsx.sheet(FIRST_SHEET)
    date = sheet.row(DATE_ROW)

    sheet.drop(TABLE_HEADER).each do |row|
      @analyzer.add_entry(row[NAME_COL], date, row[AREA_COL]) if row[AREA_COL]
    end
  end

  def start_application
    puts 'Collecting data...Done'
    sleep(1)
    loop do
      puts "\nWhat price are you looking for?"
      input = gets.chomp
      next if input.empty?

      @analyzer.process_request(input)
    end
  end
end

app = Application.new
app.start_application
