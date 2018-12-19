require 'find'
require 'pry'
require 'rubyXL'
MNSK_COL = 14
workbook = RubyXL::Parser.parse './data/Average_prices(serv)-10-2018.xlsx'
worksheets = workbook.worksheets
puts 'What price are you looking for?'
ans = gets.chomp
ans.upcase!
worksheets.each do |worksheet_rows|
  num_rows = 0
  worksheet_rows.select { |row| row&.cells&.at(0)&.value }.each do |row|
    item_name = row.cells[0].value
    price = row.cells[MNSK_COL]&.value || 'unknown'
    next unless item_name.include?(ans)

    puts "#{item_name} is #{price} BYN in Minsk these days."
    num_rows += 1
  end
    puts "#{ans} can not be found in database" if num_rows.zero?
end
prices = []
dates = []
similar_items = []
workbooks = []
Find.find('./data/') do |file|
  next unless file =~ /\b.xlsx$\b/
  workbook = RubyXL::Parser.parse(file).worksheets
  workbooks << workbook
  workbook.each do |worksheet_rows|
    num_rows = 0
    date = worksheet_rows[2][0].value
    worksheet_rows.select { |row| row&.cells&.at(0)&.value }.each_with_index do |row, index|
      price = row.cells[MNSK_COL]&.value || 0
      next unless row.cells[0].value.include?(ans)

      dates << date
      prices << price
      next unless price != 0 && !price.to_s.include?('.')

      new_price = (price.to_f / 10_000).round(2)
      prices << new_price
    end
  end
end
index_min = prices.each_with_index.min[1]
index_max = prices.select { |f| Float === f }.each_with_index.max[1]
puts "Lowest was on #{dates[index_min]} at price #{prices[index_min]} BYN"
puts "Highest was on #{dates[index_max]} at price #{prices[index_max]} BYN"
workbook = RubyXL::Parser.parse './data/Average_prices(serv)-10-2018.xlsx'
worksheets = workbook.worksheets
worksheets.each do |worksheet_rows|
  next unless worksheet_rows[2][0].value.include?('2018')

  worksheet_rows.select { |row| row&.cells&.at(0)&.value }.each do |row|
    item_price = row.cells[MNSK_COL]&.value || 0
    if item_price > prices[index_min] and item_price < prices[index_max]
      similar_items << row.cells[0].value
    end
  end
end
puts 'For similar price you also can afford:'
similar_items.first(3).each do |item|
  p item.to_s
end
