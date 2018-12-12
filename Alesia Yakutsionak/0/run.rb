require 'rubygems'
require 'bundler/setup'

Bundler.require(:default)

class ProductPrice
  LAST_PRICE_DATE = '2018/10'.freeze

  attr_accessor :min_price, :max_price, :last_price, :min_price_date, :max_price_date

  def initialize(price, date)
    @min_price = price
    @min_price_date = date
    @max_price = price
    @max_price_date = date
    @last_price = price if date == LAST_PRICE_DATE
  end

  def update(price, date)
    @last_price = price if date == LAST_PRICE_DATE
    if min_price > price
      @min_price = price
      @min_price_date = date
    end
    return unless max_price < price
    @max_price = price
    @max_price_date = date
  end
end

class PriceCollector
  MONTHS = %w(январь февраль март апрель май июнь июль август сентябрь октябрь ноябрь декабрь).freeze
  SHEET_NUM = 0
  DATE_ROW = 3
  FIRST_DATA_ROW = 8
  PRODUCT_NAME_COL = 0
  MINSK_PRICE_COL = 6

  def self.collect_data(&block)
    print 'Please wait'
    Dir['data/*'].each do |f|
      if f.end_with?('.xls')
        collect_from_xls(f, block)
      elsif f.end_with?('.xlsx')
        collect_from_xlsx(f, block)
      end
      print '.'
    end
    puts
  end

  def self.collect_from_xls(file, block)
    sheet = Roo::Excel.new(file).worksheets.first
    date = parse_date(sheet.rows[DATE_ROW - 1].compact.first)
    puts "Can't parse date in #{file}" unless date

    sheet.rows.each_with_index do |row, i|
      next if i < FIRST_DATA_ROW || row[PRODUCT_NAME_COL].nil?
      name = clean_name(row[PRODUCT_NAME_COL])
      price = row[MINSK_PRICE_COL]
      block.call(name, price, date)
    end
  end

  def self.collect_from_xlsx(file, block)
    sheet = Roo::Excelx.new(file).sheet(SHEET_NUM)
    date = parse_date(sheet.row(DATE_ROW).compact.first)
    unless date
      puts "Can't parse date in #{file}"
    end

    sheet.each_row_streaming(offset: FIRST_DATA_ROW - 1) do |row|
      name = clean_name(row[PRODUCT_NAME_COL].cell_value)
      next if name.nil?
      price = row[MINSK_PRICE_COL].cell_value
      block.call(name, price, date)
    end
  end

  def self.parse_date(date_str)
    month_index = MONTHS.index { |m| date_str.include?(m) }
    return unless month_index
    month_number = month_index + 1
    match_data = date_str.match(/(\d{4})/)
    year = match_data[1] if match_data
    return unless year
    "#{year}/#{month_number.to_s.rjust(2, '0')}"
  end

  def self.clean_name(name)
    name.to_s.gsub(%r/[a-z<\/>]/, '').squeeze(' ')
  end
end

class Products
  DENOMINATION_DATE = '2017/01'.freeze
  DENOMINATION_VALUE = 10_000

  attr_accessor :products

  def initialize
    @products = {}
  end

  def start
    PriceCollector.collect_data do |name, price, date|
      add_product(name, price, date)
    end
    user_product = ask_product
    found = search_product(user_product)
    if found.empty?
      puts "'#{user_product}' can not be found in database."
    else
      found.each do |product|
        show_found_product(product)
        show_same_price_products(found, product)
        puts
      end
    end
  end

  private

  def add_product(name, price, date)
    price = convert_price(price, date)
    existing_product = products[name]
    if existing_product
      existing_product.update(price, date)
    else
      products[name] = ProductPrice.new(price, date)
    end
  end

  def convert_price(price, date)
    price = price.to_f
    price /= DENOMINATION_VALUE if date < DENOMINATION_DATE
    price.round(2)
  end

  def ask_product
    puts 'What price are you looking for?'
    print '> '
    gets.chomp
  end

  def search_product(user_product)
    products.keys.select do |name|
      name.downcase.gsub(/[^(а-я)]/, ' ').split(/\s+/).include?(user_product.downcase) && products[name].last_price
    end
  end

  def show_found_product(product_name)
    product_price = products[product_name]
    puts "#{product_name} is #{product_price.last_price} BYN in Minsk these days."
    puts "Lowest was on #{product_price.min_price_date} at price #{product_price.min_price} BYN"
    puts "Maximum was on #{product_price.max_price_date} at price #{product_price.max_price} BYN"
  end

  def show_same_price_products(found, product_name)
    product_price = products[product_name]
    same_price_products = find_same_price(found, product_price.last_price)
    return if same_price_products.empty?
    puts "For similar price you also can afford #{same_price_products.join(' and ')}."
  end

  def find_same_price(found, price)
    same = []
    products.each do |name, product_price|
      if product_price.last_price && (product_price.last_price - price).abs < 0.03
        same << name unless found.include?(name)
        break if same.size == 2
      end
    end
    same
  end
end

Products.new.start
