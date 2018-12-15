require 'find'
require 'rubyXL'
#require 'pry'

count = 0
prices = []
dates = []
workbooks = []

puts "What price are you looking for?"
ans = gets.chomp
ans.upcase!

Find.find('./data/') do |file|
  if file =~ /\b.xlsx$\b/
    workbook = RubyXL::Parser.parse(file).worksheets
    workbooks << workbook
    workbook.each do |worksheet_rows|
      if worksheet_rows[2][0].value.include?("2018")
        current_year_prices = worksheet_rows
      end
      num_rows = 0
      date = worksheet_rows[2][0].value
      worksheet_rows.select { |row| row&.cells&.at(0)&.value }.each_with_index do |row, index|
        item_name = row.cells[0].value
        price = row.cells[14]&.value || 0
        if row.cells[0].value.include?(ans)
          dates << date
          prices << price
          if price != 0 && !price.to_s.include?(".")
            new_price = (price.to_f/10000).round(2)
            puts "#{item_name} is #{new_price} BYN #{date}"
            prices << new_price
          else
            puts "#{item_name} is #{price} BYN in Minsk these days"
          end
        end
      end
      index_min = prices.each_with_index.min[1]
      index_max = prices.select{|f| Float === f}.each_with_index.max[1]
      similar_items = []
      if worksheet_rows[2][0].value.include?("2018")
        worksheet_rows.select { |row| row&.cells&.at(0)&.value }.each_with_index do |row, index|
          item_price = row.cells[14]&.value || 0
          if item_price > prices[index_min]  && item_price < prices[index_max]
            similar_items << row.cells[0].value
          end
        end
      end
      puts "For similar price you also can afford:"
      similar_items.each do |item|
        puts "#{item}"
      end
      puts "Lowest was on #{dates[index_min]} at price #{prices[index_min]} BYN"
      puts "Highest was on #{dates[index_max]} at price #{prices[index_max]} BYN"
    end
    count += 1
  end
end
puts "#{count} files were found"
