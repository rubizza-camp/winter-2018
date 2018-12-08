class FilesParse
  def initialize
    puts "work";
  end
  def getFile(filePath)
    extention = filePath.split(".")[2];
      case extention;
      when "xls"
        fileInstance = Roo::Excel.new(filePath);
        return fileInstance;
      when "xlsx"
        fileInstance = Roo::Excelx.new(filePath);
        return fileInstance;
      else
        puts "unsupported file type: " + filePath;
        return nil;
      end
  end

  def findKeys(word, products)
    result = [];

    products.keys.each{ |key|
      if(key.include?(word))
        result.push(key);
      end
    }
    return result;
  end

  def fetchProductsData(fileInstance, products, regions)

    for n in 9..fileInstance.last_row
      if fileInstance.cell("E", n) == nil
        next;
      end

      year = fileInstance.cell("A", 3).split(" ")[2];
      month = fileInstance.cell("A", 3).split(" ")[1];

      key = fileInstance.cell("A", n).strip.downcase;

      if !products[key]
        products[key] = Hash.new;
      end
      if !products[key][year]
        products[key][year] = Hash.new;
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
      result = val.to_f;

      if year.to_i < 2017
        result = result / 10000;
      end

      return result.round(2);
    end
  end

  def getRecentPriceData(key, products, months)
    currentYear = Time.now.strftime("%Y").to_s;

    currentMonth = Time.now.strftime("%m");

    months.each{|month, monthNumber|
      if monthNumber == currentMonth
        currentMonth == month
      end
    }

    productYearData = products[key];

    if productYearData[currentYear]
      yearKey = currentYear;
    else
      yearKey = productYearData.keys.max{|a,b| a.to_i <=> b.to_i}
    end

    productMonthData = productYearData[yearKey];

    if productMonthData[currentMonth]
      monthKey = currentMonth;
    else
      monthKey = productMonthData.keys.max{|a,b| months[a] <=> months[b]}
    end

    return {
      "price" => productMonthData[monthKey]["Minsk"],
      "year" => yearKey,
      "month" => monthKey
    }
  end

  def getMinPrice(hash)
    result = Hash.new;
    minYearPrice = 9999999999999;

    hash.each{|year, yearHash|
      minMonthPrice = 9999999999999;
      yearHash.each{|month, monthHash|
        price = monthHash['Minsk']

        if(price < minMonthPrice)
          minMonthPrice = price
          result['month'] = month;
        end
      }
      if(minMonthPrice < minYearPrice)
        minYearPrice = minMonthPrice;
        result['year'] = year;
        result['price'] = minYearPrice;
      end
    }
    return result
  end

  def getMaxPrice(hash)
    result = Hash.new;
    maxYearPrice = 0;

    hash.each{|year, yearHash|
      maxMonthPrice = 0;
      yearHash.each{|month, monthHash|
        price = monthHash['Minsk']

        if(price > maxMonthPrice)
          maxMonthPrice = price;
          result['month'] = month;
        end
      }
      if(maxMonthPrice > maxYearPrice)
        maxYearPrice = maxMonthPrice;
        result['year'] = year;
        result['price'] = maxYearPrice;
      end
    }
    return result
  end
end