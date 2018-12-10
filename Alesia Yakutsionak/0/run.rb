require 'rubygems'
require 'bundler/setup'

Bundler.require(:default)

class ProductPrice
  attr_accessor :min_price, :max_price, :last_price, :min_price_date, :max_price_date

  def initialize(price, date)
    @min_price = price
    @min_price_date = date
    @max_price = price
    @max_price_date = date
    @last_price = price if date == '2018/10'
  end

  def update(price, date)
    @last_price = price if date == '2018/10'
    if min_price > price
      @min_price = price
      @min_price_date = date
    end
    if max_price < price
      @max_price = price
      @max_price_date = date
    end
  end
end

class PriceCollector
  MONTHS = %w(январь февраль март апрель май июнь июль август сентябрь октябрь ноябрь декабрь).freeze
  attr_accessor :products

  def initialize
    @products = {}
  end

  def start
    collect_data
    found = search_product(ask_product)
    found.each do |product|
      show_found_product(product)
      show_same_price_products(found, product)
      puts
    end
  end

  private

  def collect_data
    print 'Please wait'
    Dir['data/*'].each do |f|
      if f.end_with?('.xls')
        collect_from_xls(f)
      elsif f.end_with?('.xlsx')
        collect_from_xlsx(f)
      end
      print '.'
    end
    puts
  end

  def collect_from_xls(file)
    xls = Roo::Excel.new(file)
    sheet = xls.worksheets.first
    date = parse_date(sheet.rows[2].compact.first)
    puts "Can't parse date in #{file}" unless date

    sheet.rows.each_with_index do |row, i|
      next if i < 8 || row[0].nil?
      name = clean_name(row[0])
      price = row[6]
      add_product(name, price, date)
    end
  end

  def collect_from_xlsx(file)
    xlsx = Roo::Excelx.new(file)
    date = parse_date(xlsx.sheet(0).row(3).compact.first)
    puts "Can't parse date in #{file}" unless date

    xlsx.sheet(0).each_row_streaming(offset: 7) do |row|
    name = clean_name(row[0].cell_value)
      next if name.nil?
      price = row[6].cell_value
      add_product(name, price, date)
    end
  end

  def add_product(name, price, date)
    price = price.to_f
    price /= 10_000 if date < '2017/01'
    price = price.round(2)
    existing_product = products[name]
    if existing_product
      existing_product.update(price, date)
    else
      products[name] = ProductPrice.new(price, date)
    end
  end

  def parse_date(date_str)
    month = MONTHS.find{|m| date_str.include?(m)}
    return unless month
    month_number = MONTHS.index(month) + 1
    match_data = date_str.match(/(\d{4})/)
    year = match_data[1] if match_data
    return unless year
    "#{year}/#{month_number.to_s.rjust(2, '0')}"
  end

  def clean_name(name)
    name.to_s.gsub(/[a-z<\/>]/, '').squeeze(' ')
  end

  def ask_product
    puts 'What price are you looking for?'
    print '> '
    gets.chomp.downcase
  end

  def search_product(user_product)
    products.keys.select do |name|
      name.downcase.gsub(%r/[^(а-я)]/, ' ').split(/\s+/).include?(user_product) && products[name].last_price
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
    unless same_price_products.empty?
      puts "For similar price you also can afford #{same_price_products.join(' and ')}."
    end
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

PriceCollector.new.start
