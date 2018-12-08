require 'roo'
require 'roo-xls'

# The class is used to search for min and max values.
class MinMaxSearcher
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
    (9..table.last_row).each do |row|
      next unless check_product_name(row, table)

      price = fix_big_prices(table, row)
      chek_min_max(price, table.cell(row, 'A').to_s, File.basename(file, '.*'))
    end
  end

  def check_product_name(row, table)
    @products.key?(table.cell(row, 'A').to_s)
  end

  def fix_big_prices(table, row)
    year = table.cell(3, 'A').split(' ')[-2].to_i
    price = table.cell(row, @regions[@current_region]).to_f
    return (0.0001 * price).round(2) if year < 2017

    price.round(2)
  end

  def chek_min_max(price, product, date)
    if price < @products[product][1] && price != 0
      @products[product][1] = price
      @products[product][2] = date
    elsif price > @products[product][3]
      @products[product][3] = price
      @products[product][4] = date
    end
  end
end
