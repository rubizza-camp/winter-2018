require 'roo'
require 'roo-xls'

def getFileInstance(filePath)
  ext = filePath.split(".")[2]
  fileInstance = nil
  
  if ext == "xls" || ext == "xlsx"
  fileInstance = Roo::Spreadsheet.open(filePath)
  case ext
  when "xls"
    fileInstance = Roo::Excel.new(filePath)
  when "xlsx"
    fileInstance = Roo::Excelx.new(filePath)
  end
  else
  puts "unsupported file type: " + filePath
  end

  return fileInstance
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

def fetchProductsData(fileInstance, products, regions)

  for n in 9..fileInstance.last_row
  if fileInstance.cell("E", n) == nil
    next
  end

  year = fileInstance.cell("A", 3).split(" ")[2]
  month = fileInstance.cell("A", 3).split(" ")[1]

  key = fileInstance.cell("A", n).strip.downcase

  if !products[key]
    products[key] = Hash.new
  end
  if !products[key][year]
    products[key][year] = Hash.new
  end

  products[key][year][month] = {
    regions[0] => formatValue(fileInstance.cell("G", n), year),
    regions[1] => formatValue(fileInstance.cell("I", n), year),
    regions[2] => formatValue(fileInstance.cell("K", n), year),
    regions[3] => formatValue(fileInstance.cell("M", n), year),
    regions[4] => formatValue(fileInstance.cell("O", n), year),
    regions[5] => formatValue(fileInstance.cell("Q", n), year),
    regions[6] => formatValue(fileInstance.cell("S", n), year)
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

def getRecentPriceData(key, products, monthMap)
  currentYear = Time.now.strftime("%Y").to_s

  currentMonth = Time.now.strftime("%m")

  monthMap.each { |month, monthNumber|
  if monthNumber == currentMonth
    currentMonth == month
  end
  }

  productYearData = products[key];

  if productYearData[currentYear]
  yearKey = currentYear
  else
  begin
    yearKey = productYearData.keys.max{ |a,b| a.to_i <=> b.to_i}
  rescue
    puts productYearData.keys
  end
  
  end

  productMonthData = productYearData[yearKey]

  if productMonthData[currentMonth]
    monthKey = currentMonth
  else
    monthKey = productMonthData.keys.max{ |a,b| monthMap[a].to_i <=> monthMap[b].to_i}
  end

  return {
    "price" => productMonthData[monthKey]["Minsk"],
    "year" => yearKey,
    "month" => monthKey,
    "product" => key
  } 
end

def getMinPrice(hash)
  result = Hash.new
  minYearPrice = 9999999999999

  hash.each { |year, yearHash|
    minMonthPrice = 9999999999999
    yearHash.each { |month, monthHash|
      price = monthHash['Minsk']
      if !price
        next
      end
      if(price < minMonthPrice)
        minMonthPrice = price
        result['month'] = month
      end
    }
    if(minMonthPrice < minYearPrice)
      minYearPrice = minMonthPrice
      result['year'] = year
      result['price'] = minYearPrice
    end
  }
  return result
end

def getMaxPrice(hash)
  result = Hash.new
  maxYearPrice = 0

  hash.each { |year, yearHash|
    maxMonthPrice = 0
    yearHash.each { |month, monthHash|
      price = monthHash['Minsk']
      if !price
        next
      end
      if(price > maxMonthPrice)
        maxMonthPrice = price
        result['month'] = month
      end
    }
    if(maxMonthPrice > maxYearPrice)
      maxYearPrice = maxMonthPrice
      result['year'] = year
      result['price'] = maxYearPrice
    end
  }
  return result
end

def getSimilarPriceProducts(data, products)
  result = []
  price = data["price"]
  year = data["year"]
  month = data["month"]
  originProduct = data["product"]

  products.each { |product, productData|
  if !productData[year]
    next
  end
  if !productData[year][month]
    next
  end
  if productData[year][month]["Minsk"] == price && product != originProduct
    result.push(product)
  end
  }
  return result
end

def main
  monthMap = {
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
  filePaths =  Dir["./data/*"]
  
  filePaths.each { |filePath|
    fileInstance = getFileInstance(filePath)
    if fileInstance
      fetchProductsData(fileInstance, products, regions)
    end  
  }

  while true
    puts "What price are you looking for?"
    word = gets.chomp.downcase
    keys = findKeys(word, products)
    if keys.length == 0
      puts word.capitalize + " can not be found in database"
    else
      keys.each { |key|
      recentPriceData = getRecentPriceData(key, products, monthMap)
      puts "\n" + key.capitalize + " is " + recentPriceData["price"].to_s + " BYN in Minsk these days."
      minPrice = getMinPrice(products[key])
      puts "Lowest was on " + minPrice["year"] + "/" + monthMap[minPrice["month"]].to_s + " at price " + minPrice["price"].to_s + " BYN"
      maxPrice = getMaxPrice(products[key])
      puts "Maximum was on " + maxPrice["year"] + "/" + monthMap[maxPrice["month"]].to_s + " at price " + maxPrice["price"].to_s + " BYN"
      similarProducts = getSimilarPriceProducts(recentPriceData, products)
      if similarProducts.empty? == 0
        puts "No products for similar price"
      else
        puts "For similar price you also can afford"
        puts similarProducts
      end
        }
    end
  end
end

main
