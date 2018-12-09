require 'roo'
require 'roo-xls'

def get_file_instance(file_path)
  ext = file_path.split('.')[2]
  file_instance = nil
  
  if ext == 'xls' || ext == 'xlsx'
    file_instance = Roo::Spreadsheet.open(file_path)
    case ext
    when 'xls'
      file_instance = Roo::Excel.new(file_path)
    when 'xlsx'
      file_instance = Roo::Excelx.new(file_path)
    end
  else
    puts 'unsupported file type: ' + file_path
  end
  file_instance
end

def find_keys(word, products)
  result = []
  products.keys.each { |key|
    result.push(key) if(key.include?(word))
  }
  result
end

def fetch_products_data(file_instance, products, regions)
  for n in 9..file_instance.last_row
    next if file_instance.cell('E', n) == nil

    year = file_instance.cell('A', 3).split(' ')[2]
    month = file_instance.cell('A', 3).split(' ')[1]
    key = file_instance.cell('A', n).strip.downcase

    products[key] = {} unless products[key]
    products[key][year] = {} unless products[key][year]

    products[key][year][month] = {
      regions[0] => format_value(file_instance.cell('G', n), year),
      regions[1] => format_value(file_instance.cell('I', n), year),
      regions[2] => format_value(file_instance.cell('K', n), year),
      regions[3] => format_value(file_instance.cell('M', n), year),
      regions[4] => format_value(file_instance.cell('O', n), year),
      regions[5] => format_value(file_instance.cell('Q', n), year),
      regions[6] => format_value(file_instance.cell('S', n), year)
    }
  end
end

def format_value(val, year)
  if val
    result = val.to_f
    result = result / 10_000 if year.to_i < 2017
    return result.round(2)
  end
end

{
  товар => {
    год => {
      месяц => {
        регион => цена
      }
    }
  }
}

def get_recent_price_data(key, products, month_map)
  current_year = Time.now.strftime('%Y').to_s
  current_month = Time.now.strftime('%m')

  month_map.each { |month, month_number|
    current_month = month if month_number == current_month
  }

  product_year_data = products[key];

  if product_year_data[current_year]
    year_key = current_year
  else
    year_key = product_year_data.keys.max{ |a,b| a.to_i <=> b.to_i}
  end

  product_month_data = product_year_data[year_key]

  if product_month_data[current_month]
    month_key = current_month
  else
    month_key = product_month_data.keys.max{ |a,b| month_map[a].to_i <=> month_map[b].to_i}
  end

  return {
    'price' => product_month_data[month_key]['Minsk'],
    'year' => year_key,
    'month' => month_key,
    'product' => key
  } 
end

def get_min_price(hash)
  result = {}
  min_year_price = 9_999_999_999_999
  hash.each do |year, year_hash|
    min_month_price = 9_999_999_999_999
    year_hash.each do |month, month_hash|
      price = month_hash['Minsk']
      next unless price 
      if price < min_month_price
        min_month_price = price
        result['month'] = month
      end
    end
    if min_month_price < min_year_price
      min_year_price = min_month_price
      result['year'] = year
      result['price'] = min_year_price
    end
  end
  result
end

def get_max_price(hash)
  result = {}
  max_year_price = 0

  hash.each do |year, year_hash|
    max_month_price = 0
    year_hash.each do |month, month_hash|
      price = month_hash['Minsk']
      next unless price

      if price > max_month_price
        max_month_price = price
        result['month'] = month
      end
    end
    if max_month_price > max_year_price
      max_year_price = max_month_price
      result['year'] = year
      result['price'] = max_year_price
    end
  end
  result
end

def get_similar_price_products(data, products)
  result = []
  price = data['price']
  year = data['year']
  month = data['month']
  origin_product = data['product']

  products.each { |product, product_data|
    next unless product_data[year]
    next unless product_data[year][month]
    result.push(product) if product_data[year][month]['Minsk'] == price && product != origin_product
  }
  result
end

def main
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
    'декабрь' => 12,
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
        puts key.capitalize+' is '+recent_price_data['price'].to_s+' BYN in Minsk these days.'

        min_price = get_min_price(products[key])
        puts 'Lowest was on '+min_price['year']+'/'+month_map[min_price['month']].to_s +' at price '+min_price['price'].to_s+' BYN'

        max_price = get_max_price(products[key])
        puts 'Maximum was on '+max_price['year']+'/'+month_map[max_price['month']].to_s+' at price '+ max_price['price'].to_s+' BYN'

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
end

main
