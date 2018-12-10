require 'roo'
require 'roo-xls'

# application constants
FIRST_SHEET = 0
NAME_COL = 0
AREA_COL = 6
DATE_ROW = 3
TABLE_HEADER = 8
DENOMINATION_RATE = 10_000
DENOMINATION_YEAR = 2017
DELTA = 0.2
DATA_FOLDER = './data/'.freeze
MONTHS = { 'январь' => 1,
           'февраль' => 2,
           'март' => 3,
           'апрель' => 4,
           'май' => 5,
           'июнь' => 6,
           'июль' => 7,
           'август' => 8,
           'сентябрь' => 9,
           'октябрь' => 10,
           'ноябрь' => 11,
           'декабрь' => 12 }.freeze

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
  attr_accessor :latest_date, :latest_dictionary

  # @dictionary contains all data from tables
  # @latest dictionary contains data from the last month
  def initialize(dictionary = Hash.new([]), latest_dictionary = Hash.new(ProductData), latest_date = Date.new)
    @dictionary = dictionary
    @latest_dictionary = latest_dictionary
    @latest_date = latest_date
  end

  # parses date from table row
  def get_date(string)
    values = string.to_s.chomp.split(' ')
    month = values.map { |token| MONTHS[token.downcase] }.compact.first
    year = values.find { |token| /\d{4}/ =~ token }
    date = Date.new(year.to_i, month)
    @latest_date = date if latest_date < date
    date
  end

  # clears latest info, in case of obsoleteness
  def update_latest_product(latest)
    @latest_dictionary = Hash.new(ProductData) if latest
  end

  # adds product to all-data dictionary. Optionally adds product to latest data dictionary
  def add_entry(product_name, date, price, latest)
    new_entry = ProductData.new(price, date)

    new_entry.price /= DENOMINATION_RATE if date.year < DENOMINATION_YEAR

    product_name = product_name.to_s.squeeze(' ')
    reg_exp = /^[\dA-Z_]+$/
    product_name = product_name.gsub(reg_exp, '')
    @dictionary[product_name] = [] unless @dictionary.key?(product_name)
    @dictionary[product_name] << new_entry
    @latest_dictionary[product_name] = new_entry if latest
  end

  # finds similar items by price from latest dictionary
  def get_similar(latest_product, product_data)
    @latest_dictionary.each_with_object([]) do |(name, product), result|
      next if latest_product == name || !product.price.between?(product_data.price - DELTA, product_data.price + DELTA)

      result << "#{name.capitalize} with price #{product.price} BYN"
    end
  end

  # processes user input.
  # searches for product in latest dictionary
  # searches min\max price in all-data dictionary
  # searches for similar price in latest dictionary
  def process_request(input)
    processed = false

    @latest_dictionary.each do |product_name, product|
      next unless product_name.downcase.split(/[\s,]+/).include? input.downcase

      processed = true
      print_request(product_name, product, @dictionary[product_name].min_by(&:price),
                    @dictionary[product_name].max_by(&:price), get_similar(product_name, product))
    end
    puts 'Nothing found.' unless processed
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
    puts "\nFor the same price (+/- #{DELTA} BYN) you can get: "
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

  # collects data from all tables found in /data folder
  def collect_data
    puts 'Collecting data...'

    @files.each do |file|
      parse_table(file) if File.extname(file) == '.xlsx' || File.extname(file) == '.xls'
    end
    puts 'Collecting data...Done'
  end

  # parses current table
  def parse_table(file)
    xlsx = Roo::Spreadsheet.open("#{DATA_FOLDER}#{file}", extension: File.extname(file))
    sheet = xlsx.sheet(FIRST_SHEET)
    date = @analyzer.get_date(sheet.row(DATE_ROW))

    latest = date == @analyzer.latest_date
    @analyzer.update_latest_product(latest)

    sheet.drop(TABLE_HEADER).each do |row|
      @analyzer.add_entry(row[NAME_COL], date, row[AREA_COL], latest) if row[AREA_COL]
    end
  end

  # use this to start application
  def start_application
    sleep(1)
    loop do
      puts "\nWhat price are you looking for?"
      input = gets.chomp
      next if input.empty?

      @analyzer.process_request(input)
    end
  end
end

trap 'SIGINT' do
  puts 'Exiting'
  exit 0
end

app = Application.new
app.start_application
