require 'roo'
require 'roo-xls'
puts 'What price are you looking for?'
name = gets.chomp.encode('UTF-8')
number = 0

spread_sheet = Roo::Spreadsheet.open('./Data/Average.xlsx')

(1..spread_sheet.last_row).each do |row|
  next unless spread_sheet.cell(row, 1).to_s.start_with?(name.upcase)

  item = spread_sheet.cell(row, 'A')
  price = spread_sheet.cell(row, 'O')
  puts "'#{item.capitalize}' is #{price} BYN in Minsk these days."
  @number += 1
end

puts "'#{name}' can not be found in database" if number.zero?
