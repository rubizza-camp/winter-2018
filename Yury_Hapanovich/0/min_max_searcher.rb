require 'roo'
require 'roo-xls'

# The class is used to search for min and max values.
class MinMaxSearcher
  FIRST_PRODUCT_ROW = 9
  DENOMINATION_RATE = 0.0001
  DENOMINATION_YEAR = 2017

  def initialize(products, region, regions)
    @products = products
    @current_region = region
    @regions = regions
  end

  def find_min_max
    Dir['./data/*'].each do |file|
      table = Roo::Spreadsheet.open(file, extension: File.extname(file))
      scan_table(file, table)
    end
    @products
  end

  def scan_table(file, table)
    (FIRST_PRODUCT_ROW..table.last_row).each do |row|
      next unless check_product_name(row, table)

      price = fix_denominated_prices(table, row)
      compare_prices(price, table.cell(row, 'A').to_s,
                     File.basename(file, '.*'))
    end
  end

  def check_product_name(row, table)
    @products.key?(table.cell(row, 'A').to_s)
  end

  def fix_denominated_prices(table, row)
    year = table.cell(3, 'A').split(' ')[-2].to_i
    price = table.cell(row, @regions[@current_region]).to_f
    return (DENOMINATION_RATE * price).round(2) if year < DENOMINATION_YEAR

    price.round(2)
  end

  def compare_prices(price, product, date)
    if price < @products[product][1] && price != 0
      @products[product][1] = price
      @products[product][2] = date
    elsif price > @products[product][3]
      @products[product][3] = price
      @products[product][4] = date
    end
  end
end
