require 'roo'
require 'spreadsheet'

# product properties
class ProductData
  attr_reader :date, :price
  attr_writer :date, :price

  def initialize
    @price = 0
    @date = Date.new
  end
end

# collection of products
class Products
  def initialize
    @dictionary = {}
  end

  def add_entry(product_name, date, price)
    new_entry = ProductData.new
    new_entry.date = date
    new_entry.price = price

    new_entry.price /= 10_000 if date.year < 2017

    product_name = product_name.to_s.squeeze(' ')
    reg_exp = /^[\dA-Z_]+$/
    product_name = product_name.gsub(reg_exp, '')

    @dictionary[product_name] = [] unless @dictionary.key?(product_name)
    @dictionary[product_name] << new_entry
  end

  def get_same_price_products(latest_product)
    result = []
    @dictionary.each do |name, products|
      products.each do |product|
        price = latest_product.price
        next unless product.date == Date.new(2018, 10, 1) &&
                    product.price.between?(price - 0.2, price + 0.2)

        result << "#{name.capitalize} with price #{product.price} BYN"
      end
    end
    result
  end

  def process_request(input)
    @dictionary.each do |key, value|
      next unless key.downcase.include? input.downcase

      min_product = value.min_by(&:price)
      max_product = value.max_by(&:price)

      latest_product = get_latest_product(value)

      next unless latest_product

      print_request(key, latest_product, min_product, max_product)
    end
  end

  def get_latest_product(value)
    latest_product = nil
    value.each do |product|
      next unless product.date.year == 2018 && product.date.month == 10

      latest_product = product
      break
    end
    latest_product
  end

  def print_latest(key, latest_product)
    puts "#{key.capitalize} is "\
      "#{latest_product.price} BYN these days"
  end

  def print_min(min_product)
    puts 'Lowest was on '\
      "#{min_product.date.year}/#{min_product.date.month}"\
      " at price #{min_product.price} BYN"
  end

  def print_max(max_product)
    puts 'Highest was on '\
      "#{max_product.date.year}/#{max_product.date.month}"\
      " at price #{max_product.price} BYN"
  end

  def print_same_price(latest_product)
    puts 'For the same price (+/- 0.2 BYN) you can get: '
    puts get_same_price_products(latest_product)
  end

  def print_request(key, latest_product, min_product, max_product)
    puts '======================================================'
    print_latest(key, latest_product)
    print_min(min_product)
    print_max(max_product)
    print_same_price(latest_product)
  end
end

# use to parse date
class DateUtil
  def initialize
    @months = { 'январь' => 1, 'февраль' => 2, 'март' => 3, 'апрель' => 4,
                'май' => 5, 'июнь' => 6, 'июль' => 7, 'август' => 8,
                'сентябрь' => 9, 'октябрь' => 10, 'ноябрь' => 11,
                'декабрь' => 12 }
  end

  def get_date(string)
    values = string.to_s.chomp.split(' ')
    Date.new(values[2].to_i, @months[values[1]], 1)
  end
end

# use this to run application
class Application
  def initialize
    @util = DateUtil.new
    @dict = Products.new
    @files = Dir.entries('./data/')
    collect_data
  end

  def collect_data
    puts 'Collecting data...'

    @files.each do |file|
      if file.include? '.xls'
        if file.slice(file.length - 1) == 'x'
          collect_xlsx(file)
        elsif file.slice(file.length - 1) == 's'
          collect_xls(file)
        end
      end
    end
  end

  def collect_xls(file)
    xls = Spreadsheet.open "./data/#{file}"
    sheet = xls.worksheet 0

    date = @util.get_date(sheet.row(2)[0])

    sheet.drop(8).each do |row|
      @dict.add_entry(row[0], date, row[6]) if row[6]
    end
  end

  def collect_xlsx(file)
    xlsx = Roo::Spreadsheet.open("./data/#{file}")
    sheet = xlsx.sheet(0)

    date = @util.get_date(sheet.row(3))

    sheet.drop(8).each do |row|
      @dict.add_entry(row[0], date, row[6]) if row[6]
    end
  end

  def start_application
    puts 'Collecting data...Done'
    sleep(1)
    loop do
      puts ''
      puts 'What price are you looking for?'
      input = gets.chomp
      @dict.process_request(input)
    end
  end
end

app = Application.new
app.start_application
