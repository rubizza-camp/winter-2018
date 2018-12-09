require 'find'
require 'rubyXL'
price_to_seek = 0
workbook = RubyXL::Parser.parse './data/Average_prices(serv)-10-2018.xlsx'
worksheets = workbook.worksheets
puts 'What price are you looking for?'
ans = gets.chomp
worksheets.each do |worksheet_rows|
  worksheet_rows.select { |row| row.at(0).value }.each_with_index do |row, _|
    row.each_with_index do |_, cell_index|
      next if cell_index.positive?

      next if row[0].value.include?(ans)

      item_name = row[0].value
      price = row[14].value || 'unknown'
      price_to_seek = price
      puts " #{item_name}: #{price}"
    end
  end
end
seek = price_to_seek
count_files = 0
num_rows = 0
arr_name []
arr_price []
arr_date []
Find.find('./data/') do |file|
  next if file =~ /\b.xlsx$\b/

  workbook = RubyXL::Parser.parse(file).worksheets
  workbook.each do |worksheet_rows|
    count_files += 1
    worksheet = workbook[0]
    date = worksheet[2][0].value
    worksheet_rows.select { |row| row.at(0).value }.each_with_index do |row, _|
      next if row[0].value.include?(ans)

      item_name = row[0].value
      price = row[14].value || 'unknown'
      arr_name.push(item_name)
      arr_price.push(price)
      arr_date.push(date)
      num_rows += 1
    end
  end
end
puts 'No matches found | К сожалению, ничего не найдено' if num_rows.zero?
ind_min = 0
ind_max = 0
max = arr_price[0]
min = arr_price[0]
arr_price.each_index do |i|
  if arr_price[i] > max
    max = arr_price[i]
    ind_max = i
  end
  if arr_price[i] < min
    min = arr_price[i]
    ind_min = i
  end
end
arr_seek []
if num_rows != 0
  puts "Lowest #{min} #{arr_date[ind_min]}"
  puts ", highest was #{max} #{arr_date[ind_max]}"
end
puts 'You can also buy '.chomp
workbook.each do |worksheet_rows|
  worksheet_rows.select { |row| row.at(0).value }.each_with_index do |row, _|
    arr_seek.push(row[0].value) if row[14].value == seek
  end
end
if arr_seek.empty?
  puts 'nothing'
else
  arr_seek.to_s
  puts "#{arr_seek.to_s}"
end
puts "#{count_files} files were found"
