class FilesParse

  attr_accessor    :current_Month,
  :current_Year
  def initialize
    puts 'work'
    @current_Month = Time.now.strftime('%m')
    @current_Year = Time.now.strftime('%Y').to_s
  end

  def get_Mount(month, monthNumber)
    current_Months = @current_Month
    if monthNumber == @current_Month
      return current_Months = month
    end
    current_Months
  end

  def get_Year_Key(products, key, product_Year_Data)
    if product_Year_Data[@current_Year]
      return @current_Year
    else
      return product_Year_Data.keys.max{|a,b| a.to_i <=> b.to_i}
    end
  end

  def get_Month_Key(product_Month_Data, current_Months, month_Map)
    if product_Month_Data[current_Months]
      return current_Months
    else
      return product_Month_Data.keys.max{|a,b| month_Map[a] <=> month_Map[b]}
    end
  end

  def get_Recent_Price_Data(key, products, month_Map)
    current_Months = @current_Month
    month_Map.each do |month, monthNumber|
      current_Months = get_Mount(month, monthNumber)
    end
    product_Year_Data = products[key]
    year_Key = get_Year_Key(products, key, product_Year_Data)
    product_Month_Data = product_Year_Data[year_Key]
    month_Key = get_Month_Key(product_Month_Data, current_Months, month_Map)
    {"price" => product_Month_Data[month_Key]["Minsk"], "year" => year_Key, "month" => month_Key }
  end

  def get_File(file_Path)
    extention = file_Path.split('.')[2]
    case extention
    when 'xls'
      file = Roo::Excel.new(file_Path)
    when 'xlsx'
      file = Roo::Excelx.new(file_Path)
    else
      puts 'unsupported file type: ' + file_Path
    end
    file;
  end

  def find_Keys(word, products)
    keys = []
    products.keys.each{ |key|
      if(key.include?(word))
        keys.push(key)
      end
    }
    keys
  end

  def fetch_Products_Data(file, products, regions)
    for index in 9..file.last_row
      next if file.cell('E', index) == nil
      year = file.cell('A', 3).split(' ')[2]
      month = file.cell('A', 3).split(' ')[1]
      key = file.cell('A', index).strip.downcase
      add_Products(products, year, month, key, regions, file, index)
    end
  end

  def add_Products(products, year, month, key, regions, file, index)
    products[key] = {} unless products[key]
    products[key][year] = {} unless products[key][year]
    products[key][year][month] = {
      regions[0] => format_Value(file.cell('G', index), year),
      regions[1] => format_Value(file.cell('I', index), year),
      regions[2] => format_Value(file.cell('K', index), year),
      regions[3] => format_Value(file.cell('M', index), year),
      regions[4] => format_Value(file.cell('O', index), year),
      regions[5] => format_Value(file.cell('Q', index), year),
      regions[6] => format_Value(file.cell('S', index), year)}
  end

  def format_Value(val, year)
    if val
      result = val.to_f

      if year.to_i < 2017
        result = result / 10000
      end

      result.round(2)
    end
  end

  def get_Min_Price(hash)
    min_year_price = 111_111_111
    result = {}
    hash.each do |year, year_hash|
      min_month_data = find_min_month(year_hash)
      puts(min_month_data)
      min_year_data = find_min_year(year, min_month_data, min_year_price)
      min_year_price = min_year_data['price'] if min_year_data['price']
      result = actual_data(result, min_year_data)
    end
    result
  end

  def find_min_month(year_hash, min_month_price = 111_111_111, min_month = nil)
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

  def get_Max_Price(hash)
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
end
