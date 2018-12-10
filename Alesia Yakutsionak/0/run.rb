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
  MONTHS = %w(январь февраль март апрель май июнь июль август сентябрь октябрь ноябрь декабрь)
  attr_accessor :products

  def initialize
    @products = {}
  end

  def start
    collect_data
    found = search_product(ask_product)
    show_found_products(found)
   # puts "Кол-во продуктов: #{products.size}"
  end

  private

  def collect_data
    Dir['data/*'].each do |f|
      if f.end_with?('.xls')
        collect_from_xls(f)
      elsif f.end_with?('.xlsx')
        collect_from_xlsx(f)
      end
    end
  end

  def collect_from_xls(f)
    xls = Roo::Excel.new(f)
    sheet = xls.worksheets.first
    date = parse_date(sheet.rows[2].compact.first)
    puts "Can't parse date in #{f}" unless date

    sheet.rows.each_with_index do |row,i|
      next if i < 8 || row[0].nil?
      name = clean_name(row[0])
      price = row[6].to_f.round(2)
      add_product(name, price, date)
    end
  end

  def collect_from_xlsx(f)
    xlsx = Roo::Excelx.new(f)
    date = parse_date(xlsx.sheet(0).row(3).compact.first)
    puts "Can't parse date in #{f}" unless date

    xlsx.sheet(0).each_row_streaming(offset: 7) do |row|
    name = clean_name(row[0].cell_value)
      next if name.nil?
      price = row[6].cell_value.to_f.round(2)
      add_product(name, price, date)
    end
  end

  def add_product(name, price, date)
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
    year = $1 if date_str.match(/(\d{4})/)
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
      name.downcase.include?(user_product) && products[name].last_price
    end
  end

  def show_found_products(found)
    found.each do |p|
      product_price = products[p]
      puts "#{p} is #{product_price.last_price}BYN in Minsk these days."
      puts "Lowest was on #{product_price.min_price_date} at price #{product_price.min_price}BYN"
      puts "Maximum was on #{product_price.max_price_date} at price #{product_price.max_price}BYN"
    end
  end
end


PriceCollector.new.start





