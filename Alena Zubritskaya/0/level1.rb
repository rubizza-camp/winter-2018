require 'rubyXL'
require 'pry'
MNSK_COL = 14
workbook = RubyXL::Parser.parse './data/Average_prices2018.xlsx'
worksheets = workbook.worksheets
puts "Found #{worksheets.count} worksheet"

worksheets.each do |worksheet_rows|
  num_rows = 0
  puts 'What price are you looking for?'
  ans = gets.chomp
  ans.upcase!
  worksheet_rows.select { |row| row&.cells&.at(0)&.value }.each_with_index do |row, index|
    item_name = row.cells[0].value
    price = row.cells[MNSK_COL]&.value || "unknown"
    if item_name.include?(ans)
    puts "#{item_name} is #{price} BYN in Minsk these days."
    num_rows += 1
  end
end
  if num_rows==0
  puts  "#{ans} can not be found in database"
  end
end
