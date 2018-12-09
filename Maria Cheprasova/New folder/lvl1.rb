require 'find'
require 'rubyXL'
array=Array.new
price_to_seek=0
workbook = RubyXL::Parser.parse './data/Average_prices(serv)-10-2018.xlsx'
worksheets = workbook.worksheets
worksheets.each do |worksheet_rows|
  puts "What price are you looking for?"
  ans = gets.chomp
  worksheet_rows.select { |row| row&.cells&.at(0)&.value }.each_with_index do |row, index|
    row.cells.each_with_index do |cell, cell_index|
      next if cell_index.positive?
    if  row.cells[0].value.include?(ans)
      item_name = row.cells[0].value
      price = row.cells[14]&.value || "unknown"
      price_to_seek=price
    puts " #{item_name}: #{price}"
    end
    end
end
seek=price_to_seek
count_files=0
num_rows = 0
arr_name=Array.new
arr_price=Array.new
arr_date=Array.new
    Find.find('./data/') do |file|
      if file =~ /\b.xlsx$\b/
        workbook = RubyXL::Parser.parse(file).worksheets
        workbook.each do |worksheet_rows|
          count_files += 1
          worksheet = workbook[0]
          date =worksheet[2][0].value
          worksheet_rows.select { |row| row&.cells&.at(0)&.value }.each_with_index do |row, index|
            if row.cells[0].value.include?(ans)
              item_name = row.cells[0].value
              price = row.cells[14]&.value || "unknown"
              arr_name.push(item_name)
              arr_price.push(price)
              arr_date.push(date)
              num_rows+=1
            end
          end
        end

      end
    end
  if  num_rows ==0
    puts 'No matches found | К сожалению, ничего не найдено'
    else
  end
ind_min=0
ind_max=0
max=arr_price[0]
min=arr_price[0]
arr_price.each_index do |i|
  if arr_price[i]>max
    max=arr_price[i]
    ind_max=i
  end
  if arr_price[i]<min
    min=arr_price[i]
    ind_min=i
    end
end
  arr_seek=Array.new
  if num_rows!=0
puts "Lowest #{min} #{arr_date[ind_min]}, highest was #{max} #{arr_date[ind_max]} "
end
puts "You can also buy ".chomp
workbook.each do |worksheet_rows|
  worksheet_rows.select { |row| row&.cells&.at(0)&.value }.each_with_index do |row, index|
    if row&.cells[14]&.value==seek
      arr_seek.push(row&.cells[0]&.value)
    end
  end
end
  if arr_seek.empty?
    puts "nothing"
else puts "#{arr_seek}"
  end
puts "#{count_files} files were found"
end