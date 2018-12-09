require 'roo'
require 'roo-xls'

REGION = 7 # Tab for Minsk
GOODS = 'A'.freeze # Tab for products' names

# Level 1
current = Dir.glob('./data/*').max
table = Roo::Spreadsheet.open(current, extension: File.extname(current))

print "What price are you looking for?\n>\s"
item = gets.chomp

products = (9..table.last_row).each_with_object({}) do |row, products|
  next unless table.cell(row, GOODS).to_s =~ /\b#{item.upcase}\b/

  name = table.cell(row, GOODS)
  price = table.cell(row, REGION)
  products[name] = price
  puts "'#{name.capitalize}' is #{price} BYN in Minsk these days."
end

if products.size.zero?
  puts "'#{item}' can not be found in database."
  exit
end

# Level 2
month_min = File.basename(current, File.extname(current))
month_max = File.basename(current, File.extname(current))
products.each do |name, price|
  price_min = price
  price_max = price
  Dir.glob('./data/*').each do |file|
    sheet = Roo::Spreadsheet.open(file, extension: File.extname(file))
    (9..sheet.last_row).each do |row|
      next unless sheet.cell(row, GOODS).to_s == name

      chk_price = if file > './data/2017' # Check for denomination
                    sheet.cell(row, REGION)
                  else
                    sheet.cell(row, REGION) / 10_000
                  end
      if chk_price > price
        price_min = chk_price
        month_min = File.basename(file, File.extname(file))
      end
      if chk_price < price
        price_max = chk_price
        month_max = File.basename(file, File.extname(file))
      end
    end
  end
  puts <<~LOWEST
    Lowest for '#{name.capitalize}' was on #{month_min} at price #{price_min} BYN
  LOWEST
  puts <<~MAXIMUM
    Maximum for '#{name.capitalize}' was on #{month_max} \at price #{price_max} BYN
  MAXIMUM
end

# Level 3
DELTA = 0.25 # delta for searching for similar prices
DELTA.freeze
products.each do |name, price|
  sim_prod = []
  similar = (9..table.last_row).each_with_object({}) do |row, similar|
    next if table.cell(row, GOODS).to_s == name
    next if table.cell(row, REGION).nil?

    if (price - table.cell(row, REGION)).abs <= DELTA
      sim_prod << table.cell(row, GOODS).capitalize
      similar[name] = sim_prod
    end
  end
  if similar.length.zero?
    puts 'No products with similar price found.'
  else
    puts <<~SIMILAR
      For similar price as '#{name.capitalize}' you also can afford: #{similar[name].map { |sim| "'#{sim}'" }.join(', ')}.
    SIMILAR
  end
end
