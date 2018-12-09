require 'rubyXL'
require 'pry'

workbook = RubyXL::Parser.parse './data/Average_prices2018.xlsx'
worksheets = workbook.worksheets
puts "Found #{worksheets.count} worksheets"

worksheets.each do |worksheet_rows|
  puts "Reading: #{worksheet_rows.sheet_name}"
  num_rows = 0

  puts "What price are you looking for?"
  ans = gets.chomp
  ans.upcase!

  worksheet.each do |row|
    row_cells = row.cells.map{ |cell| cell.value }
    num_rows += 1
    puts row_cells.join " "
  end


  worksheet_rows.select { |row| row&.cells&.at(0)&.value }.each_with_index do |row, index|
    item_name = row.cells[0].value
    price = row.cells[14]&.value || "unknown"
    if row.cells[0].value.include?(ans)
    puts "#{item_name} is #{price} BYN in Minsk these days."
    puts "#{date}"
    binding.pry
    num_rows+=1
  end
  end
  if
    num_rows==0
  puts  "#{ans} can not be found in database"
  end

end
