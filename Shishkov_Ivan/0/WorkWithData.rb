class FilesParse
  def initialize
    puts "work"
  end
  def get_File(file_Path)
    extention = file_Path.split(".")[2]
      case extention
      when "xls"
        file = Roo::Excel.new(file_Path)
        return file;
      when "xlsx"
        file = Roo::Excelx.new(file_Path)
        return file
      else
        puts "unsupported file type: " + file_Path
        return nil;
      end
  end

  def find_Keys(word, products)
    result = []

    products.keys.each{ |key|
      if(key.include?(word))
        result.push(key)
      end
    }
    return result
  end

  def fetch_Products_Data(file, products, regions)

    for n in 9..file.last_row
      if file.cell("E", n) == nil
        next
      end

      year = file.cell("A", 3).split(" ")[2]
      month = file.cell("A", 3).split(" ")[1]

      key = file.cell("A", n).strip.downcase

      if !products[key]
        products[key] = Hash.new
      end
      if !products[key][year]
        products[key][year] = Hash.new
      end

      products[key][year][month] = {
        regions[0] => format_Value(file.cell("G", n), year),
        regions[1] => format_Value(file.cell("I", n), year),
        regions[2] => format_Value(file.cell("K", n), year),
        regions[3] => format_Value(file.cell("M", n), year),
        regions[4] => format_Value(file.cell("O", n), year),
        regions[5] => format_Value(file.cell("Q", n), year),
        regions[6] => format_Value(file.cell("S", n), year)
      }
    end
  end

  def format_Value(val, year)
    if val
      result = val.to_f

      if year.to_i < 2017
        result = result / 10000
      end

      return result.round(2)
    end
  end

  def get_Recent_Price_Data(key, products, months)
    currentYear = Time.now.strftime("%Y").to_s

    current_Month = Time.now.strftime("%m")

    months.each{|month, month_Number|
      if month_Number == current_Month
        current_Month == month
      end
    }

    product_Year_Data = products[key]

    if product_Year_Data[currentYear]
      yearKey = currentYear
    else
      yearKey = product_Year_Data.keys.max{|a,b| a.to_i <=> b.to_i}
    end

    product_Month_Data = product_Year_Data[yearKey]

    if product_Month_Data[current_Month]
      monthKey = current_Month
    else
      monthKey = product_Month_Data.keys.max{|a,b| months[a] <=> months[b]}
    end

    return {
      "price" => product_Month_Data[monthKey]["Minsk"],
      "year" => yearKey,
      "month" => monthKey
    }
  end

  def get_Min_Price(hash)
    result = Hash.new
    min_Year_Price = hash[hash.keys[0]]
    hash.each{|year, year_Hash|
      min_Month_Price = 111111111
      year_Hash.each{|month, month_Hash|
        price = month_Hash['Minsk']
        if price
          if(price < min_Month_Price)
            min_Month_Price = price
            result['month'] = month
          end
        end  
      }
      if(min_Month_Price < min_Year_Price)
        min_Year_Price = min_Month_Price
        result['year'] = year
        result['price'] = min_Year_Price
      end
    }
    return result
  end

  def get_Max_Price(hash)
    result = Hash  {}
    max_Year_Price = 0

    hash.each{ |year, year_Hash|
      max_Month_Price = 0
      year_Hash.each { |month, month_Hash|
        price = month_Hash['Minsk']

        if(price > max_Month_Price)
          max_Month_Price = price
          result['month'] = month
        end
      }
      if(max_Month_Price > max_Year_Price)
        max_Year_Price = max_Month_Price
        result['year'] = year
        result['price'] = max_Year_Price
      end
    }
    return result
  end
end
