require 'roo'
require 'roo-xls'

# Level 1
current = Dir.glob('./data/*').max
table = Roo::Spreadsheet.open(current, extension: File.extname(current))

print "What price are you looking for?\n>\s"
item = gets.chomp

found = 0
products = []
prices = []
(9..table.last_row).each do |row|
  next unless table.cell(row, 'A').to_s.start_with? item.upcase

  products << product = table.cell(row, 'A')
  prices << price = table.cell(row, 7)
  puts "'#{product.capitalize}' is #{price} BYN in Minsk these days."
  found += 1
end

if found.zero?
  puts "'#{item}' can not be found in database."
  exit
end

# Level 2
prices_min = [].replace(prices)
prices_max = [].replace(prices)
month_min = File.basename(current, File.extname(current))
month_max = File.basename(current, File.extname(current))
(0...products.length).each do |prod|
  Dir.glob('./data/*').each do |file|
    sheet = Roo::Spreadsheet.open(file, extension: File.extname(file))
    (9..sheet.last_row).each do |row|
      next unless sheet.cell(row, 'A').to_s == products[prod]

      price = if File.basename(file, File.extname(file)) > '2017'
                sheet.cell(row, 7)
              else
                sheet.cell(row, 7) / 10_000
              end
      if prices_min[prod] > price
        prices_min[prod] = price
        month_min = File.basename(file, File.extname(file))
      end
      if prices_max[prod] < price
        prices_max[prod] = price
        month_max = File.basename(file, File.extname(file))
      end
    end
  end
  puts <<~LOWEST
    Lowest for '#{products[prod].capitalize}' was on #{month_min} at price #{prices_min[prod]} BYN
  LOWEST
  puts <<~MAXIMUM
    Maximum for '#{products[prod].capitalize}' was on #{month_max} \at price #{prices_max[prod]} BYN
  MAXIMUM
end

# Level 3
DELTA = 0.25 # delta for searching any similar prices
DELTA.freeze
(0...prices.length).each do |price|
  similar = []
  found_similar = 0
  (9..table.last_row).each do |row|
    next if table.cell(row, 'A').to_s == products[price]
    next if table.cell(row, 7).nil?

    if (prices[price] - table.cell(row, 7)).abs <= DELTA
      similar << table.cell(row, 'A').capitalize
      found_similar += 1
    end
  end
  if found_similar.zero?
    puts 'No products with similar price found.'
  else
    puts "For similar price as '#{products[price].capitalize}' \
you also can afford: #{similar.map { |sim| "'#{sim}'" }.join(', ')}."
  end
end
