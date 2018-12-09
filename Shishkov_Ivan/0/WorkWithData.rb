class FilesParse

  attr_accessor    :current_month,
  :current_year
  def initialize
    puts 'work'
    @current_month = Time.now.strftime('%m')
    @current_year = Time.now.strftime('%Y').to_s
  end

  def get_mount(month, monthNumber)
    current_months = @current_month
    if monthNumber == @current_month
      return current_months = month
    end
    current_months
  end

  def get_year_key(products, key, product_year_data)
    if product_year_data[@current_year]
      return @current_year
    else
      return product_year_data.keys.max{|a,b| a.to_i <=> b.to_i}
    end
  end

  def get_month_key(product_month_data, current_months, month_Map)
    if product_month_data[current_months]
      return current_months
    else
      return product_month_data.keys.max{|a,b| month_Map[a] <=> month_Map[b]}
    end
  end

  def get_recent_price_data(key, products, month_Map)
    current_months = @current_month
    month_Map.each do |month, monthNumber|
      current_months = get_mount(month, monthNumber)
    end
    product_year_data = products[key]
    year_Key = get_year_key(products, key, product_year_data)
    product_month_data = product_year_data[year_Key]
    month_key = get_month_key(product_month_data, current_months, month_Map)
    {'price' => product_month_data[month_key]['Minsk'], 'year' => year_Key, 'month' => month_key }
  end

  def get_file(file_path)
    extention = file_path.split('.')[2]
    if extention == 'xls' || extention == 'xlsx'
      file = Roo::Excelx.new(file_path)
    else
      puts 'unsupported file type: ' + file_path
    end
    file
  end

  def find_keys(word, products)
    keys = []
    products.keys.each do |key|
      keys.push(key) if (key.include?(word))
    end
    keys
  end

  def fetch_products_data(file, products, regions)
    for index in 9..file.last_row
      next if file.cell('E', index).nil?
      year = file.cell('A', 3).split(' ')[2]
      month = file.cell('A', 3).split(' ')[1]
      key = file.cell('A', index).strip.downcase
      add_products(products, year, month, key, regions, file, index)
    end
  end

  def add_products(products, year, month, key, regions, file, index)
    products[key] = {} unless products[key]
    products[key][year] = {} unless products[key][year]
    products[key][year][month] = {    
      regions[0] => format_value(file.cell('G', index), year),
      regions[1] => format_value(file.cell('I', index), year),
      regions[2] => format_value(file.cell('K', index), year),
      regions[3] => format_value(file.cell('M', index), year),
      regions[4] => format_value(file.cell('O', index), year),
      regions[5] => format_value(file.cell('Q', index), year),
      regions[6] => format_value(file.cell('S', index), year) 
}
  end

  def format_value(val, year)
    if val
      result = val.to_f

      if year.to_i < 2017
        result = result / 10000
      end

      result.round(2)
    end
  end

  def get_min_price(hash)
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
end
