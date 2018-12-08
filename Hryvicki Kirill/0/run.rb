require 'roo'
require 'roo-xls'

def getFileInstance(filePath)
  ext = filePath.split(".")[2]
  file_instance = nil
  
  if ext == "xls" || ext == "xlsx"
  file_instance = Roo::Spreadsheet.open(filePath)
  case ext
  when "xls"
    file_instance = Roo::Excel.new(filePath)
  when "xlsx"
    file_instance = Roo::Excelx.new(filePath)
  end
  else
  puts 'unsupported file type: ' + filePath
  end

  return file_instance
end

def findKeys(word, products)
  result = []

  products.keys.each { |key|
  if(key.include?(word))
    result.push(key)
  end
  }
  return result
end

def fetchProductsData(file_instance, products, regions)

  for n in 9..file_instance.last_row
  if file_instance.cell("E", n) == nil
    next
  end

  year = file_instance.cell("A", 3).split(" ")[2]
  month = file_instance.cell("A", 3).split(" ")[1]

  key = file_instance.cell("A", n).strip.downcase

  if !products[key]
    products[key] = Hash.new
  end
  if !products[key][year]
    products[key][year] = Hash.new
  end

  products[key][year][month] = {
    regions[0] => formatValue(file_instance.cell("G", n), year),
    regions[1] => formatValue(file_instance.cell("I", n), year),
    regions[2] => formatValue(file_instance.cell("K", n), year),
    regions[3] => formatValue(file_instance.cell("M", n), year),
    regions[4] => formatValue(file_instance.cell("O", n), year),
    regions[5] => formatValue(file_instance.cell("Q", n), year),
    regions[6] => formatValue(file_instance.cell("S", n), year)
  }
  end
end

def formatValue(val, year)
  if val
  result = val.to_f

  if year.to_i < 2017
    result = result / 10000
  end

  return result.round(2)
  end
end

def getRecentPriceData(key, products, month_map)
  current_year = Time.now.strftime("%Y").to_s
  current_month = Time.now.strftime("%m")

  month_map.each { |month, month_number|
  if month_number == current_month
    current_month == month
  end
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
    "price" => product_month_data[month_key]["Minsk"],
    "year" => year_key,
    "month" => month_key,
    "product" => key
  } 
end

def getMinPrice(hash)
  result = Hash.new
  min_year_price = 9999999999999

  hash.each { |year, year_hash|
    min_month_price = 9999999999999
    year_hash.each { |month, month_hash|
      price = month_hash['Minsk']
      if !price
        next
      end
      if(price < min_month_price)
        min_month_price = price
        result['month'] = month
      end
    }
    if(min_month_price < min_year_price)
      min_year_price = min_month_price
      result['year'] = year
      result['price'] = min_year_price
    end
  }
  return result
end

def getMaxPrice(hash)
  result = Hash.new
  max_year_price = 0

  hash.each { |year, year_hash|
    max_month_price = 0
    year_hash.each { |month, month_hash|
      price = month_hash['Minsk']
      if !price
        next
      end
      if(price > max_month_price)
        max_month_price = price
        result['month'] = month
      end
    }
    if(max_month_price > max_year_price)
      max_year_price = max_month_price
      result['year'] = year
      result['price'] = max_year_price
    end
  }
  return result
end

def getSimilarPriceProducts(data, products)
  result = []
  price = data["price"]
  year = data["year"]
  month = data["month"]
  origin_product = data["product"]

  products.each { |product, product_data|
  if !product_data[year]
    next
  end
  if !product_data[year][month]
    next
  end
  if product_data[year][month]["Minsk"] == price && product != origin_product
    result.push(product)
  end
  }
  return result
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
  products = Hash.new
  file_paths =  Dir["./data/*"]
  
  file_paths.each { |filePath|
    file_instance = getFileInstance(filePath)
    if file_instance
      fetchProductsData(file_instance, products, regions)
    end  
  }

  loop do
    puts 'What price are you looking for?'
    word = gets.chomp.downcase  #.encode("UTF-8")
    keys = findKeys(word, products)
    if keys.empty?
      puts word.capitalize + ' can not be found in database'
    else
      keys.each { |key|
        recent_price_data = getRecentPriceData(key, products, month_map)
        puts ''
        puts key.capitalize + ' is ' + recent_price_data["price"].to_s + ' BYN in Minsk these days.'

        min_price = getMinPrice(products[key])
        puts 'Lowest was on ' + min_price["year"] + '/' + month_map[min_price["month"]].to_s +
        ' at price ' + min_price["price"].to_s + ' BYN'

        max_price = getMaxPrice(products[key])
        puts 'Maximum was on ' + max_price["year"] + '/' + month_map[max_price["month"]].to_s +
        ' at price ' + max_price["price"].to_s + ' BYN'

        similar_products = getSimilarPriceProducts(recent_price_data, products)
        if similar_products.empty?
          puts 'No products for similar price'
        else
          puts 'For similar price you also can afford'
          puts similar_products
        end
      }
    end
  end
end

main
