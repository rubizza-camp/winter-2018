require 'roo'
require 'roo-xls'

def get_file_instance(file_path)
  ext = file_path.split('.')[2]
  file_instance = nil
  if ext.include?('xls')
    Roo::Spreadsheet.open(file_path)
    file_instance = conditiona_load(ext, file_path)
  else
    puts 'unsupported file type: ' + file_path
  end
  file_instance
end

def conditiona_load(ext, file_path)
  case ext
  when 'xls'
    sheet = Roo::Excel.new(file_path)
  when 'xlsx'
    sheet = Roo::Excelx.new(file_path)
  end
  sheet
end

def find_keys(word, products)
  result = []
  products.keys.each { |key| result.push(key) if key.include?(word) }
  result
end

def fetch_products_data(file_instance, products, regions)
  for n in 9..file_instance.last_row
    next if file_instance.cell('E', n).nil?

    year = file_instance.cell('A', 3).split(' ')[2]
    month = file_instance.cell('A', 3).split(' ')[1]
    key = file_instance.cell('A', n).strip.downcase
    meta = [key, year, month]
    add_product(products, meta, regions, file_instance, n)
  end
end

def add_product(products, meta, regions, file_instance, num)
  key = meta[0]
  year = meta[1]
  month = meta[2]
  products[key] = {} unless products[key]
  products[key][year] = {} unless products[key][year]
  products[key][year][month] = { regions[4] => format_value(file_instance.cell('O', num), year) }
end

def format_value(val, year)
  return if val.nil?

  result = val.to_f
  result /= 10_000 if year.to_i < 2017
  result.round(2)
end

def get_recent_price_data(key, products, month_map)
  current_year = Time.now.strftime('%Y').to_s
  current_month = parse_month(month_map)
  product_year_data = products[key]
  year_key = get_closest_year(current_year, product_year_data)
  product_month_data = product_year_data[year_key]
  month_key = get_closest_month(current_month, product_month_data, month_map)
  form_recent_price_data(product_month_data[month_key]['Minsk'], year_key, month_key, key)
end

def form_recent_price_data(price, year, month, product)
  {
    'price' => price,
    'year' => year,
    'month' => month,
    'product' => product
  }
end

def parse_month(month_map)
  current_month = Time.now.strftime('%m')
  month_map.each { |month, month_number| current_month = month if month_number == current_month }
  current_month
end

def get_closest_year(current_year, product_data)
  current_year if product_data[current_year]
  product_data.keys.max_by(&:to_i) unless product_data[current_year]
end

def get_closest_month(current_month, product_data, month_map)
  current_month if product_data[current_month]
  product_data.keys.max { |a, b| month_map[a].to_i <=> month_map[b].to_i } unless product_data[current_month]
end

def get_min_price(hash)
  min_year_price = 9_999_999_999_999
  result = {}
  hash.each do |year, year_hash|
    min_month_data = find_min_month(year_hash)
    min_year_data = find_min_year(year, min_month_data, min_year_price)
    min_year_price = min_year_data['price'] if min_year_data['price']
    result = actual_data(result, min_year_data)
  end
  result
end

def find_min_month(year_hash, min_month_price = 9_999_999_999_999, min_month = nil)
  year_hash.each do |month, month_hash|
    price = month_hash['Minsk']
    next unless price

    if price < min_month_price
      min_month_price = price
      min_month = month
    end
  end
  { 'price' => min_month_price, 'month' => min_month }
end

def find_min_year(year, min_month_data, min_year_price)
  result = {}
  min_month_price = min_month_data['price']
  result['month'] = min_month_data['month']
  if min_month_price < min_year_price
    result['price'] = min_month_price
    result['year'] = year
  end
  result
end

def get_max_price(hash)
  max_year_price = 0
  result = {}
  hash.each do |year, year_hash|
    max_month_data = find_max_month(year_hash)
    max_year_data = find_max_year(year, max_month_data, max_year_price)
    max_year_price = max_year_data['price'] if max_year_data['price']
    result = actual_data(result, max_year_data)
  end
  result
end

def find_max_month(year_hash, max_month_price = 0, max_month = nil)
  year_hash.each do |month, month_hash|
    price = month_hash['Minsk']
    next unless price

    if price > max_month_price
      max_month_price = price
      max_month = month
    end
  end
  { 'price' => max_month_price, 'month' => max_month }
end

def find_max_year(year, max_month_data, max_year_price)
  result = {}
  max_month_price = max_month_data['price']
  result['month'] = max_month_data['month']
  if max_month_price > max_year_price
    result['price'] = max_month_price
    result['year'] = year
  end
  result
end

def actual_data(result, year_data)
  result['month'] = year_data['month']
  result['price'] = year_data['price'] if year_data['price']
  result['year'] = year_data['year'] if year_data['year']
  result
end

def get_similar_price_products(data, products)
  price = data['price']
  year = data['year']
  month = data['month']
  origin_product = data['product']
  form_similar_products_array(products, price, year, month, origin_product)
end

def form_similar_products_array(products, price, year, month, origin_product)
  result = []
  products.each do |product, product_data|
    next unless product_data[year]

    next unless product_data[year][month]

    result.push(product) if product_data[year][month]['Minsk'] == price && product != origin_product
  end
  result
end

month_map = {
  'январь' => 1,
  'февраль' => 2,
  'март' => 3,
  'апрель' => 4,
  'май' => 5,
  'июнь' => 6,
  'июль' => 7,
  'авуст' => 8,
  'сентябрь' => 9,
  'октябрь' => 10,
  'ноябрь' => 11,
  'декабрь' => 12
}
regions = ['Brest', 'Vitebsk', 'Gomel', 'Grodno', 'Minsk', 'Minsk Region', 'Mogilyov']
products = {}
file_paths = Dir['./data/*']
file_paths.each do |file_path|
  file_instance = get_file_instance(file_path)
  fetch_products_data(file_instance, products, regions) if file_instance
end
loop do
  puts 'What price are you looking for?'
  word = gets.chomp.downcase # .encode('UTF-8')
  keys = find_keys(word, products)
  if keys.empty?
    puts word.capitalize + ' can not be found in database'
  else
    keys.each do |key|
      recent_price_data = get_recent_price_data(key, products, month_map)
      puts ''
      puts key.capitalize + ' is ' + recent_price_data['price'].to_s + ' BYN in Minsk these days.'
      min_price = get_min_price(products[key])
      puts 'Lowest was on ' + min_price['year'] + '/' + month_map[min_price['month']].to_s + ' at price '
      print min_price['price'].to_s + ' BYN'
      max_price = get_max_price(products[key])
      puts 'Maximum was on ' + max_price['year'] + '/' + month_map[max_price['month']].to_s + ' at price '
      print max_price['price'].to_s + ' BYN'
      similar_products = get_similar_price_products(recent_price_data, products)
      if similar_products.empty?
        puts 'No products for similar price'
      else
        puts 'For similar price you also can afford'
        puts similar_products
      end
    end
  end
end
