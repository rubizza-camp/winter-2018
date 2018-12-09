require 'rubyXL'

workbook = RubyXL::Parser.parse '/home/kos1kov/Average_prices(serv)-10-2018.xlsx'

worksheets = workbook.worksheets
puts 'What price are you looking for?'
product = gets.chomp
flag = 0
worksheets.each do |worksheet|
  worksheet.each do |row|
    next if row.nil?

    @row_cells = row && row.cells.map { |cell| cell && cell.value }
    next if @row_cells[0].nil?

    if @row_cells[0].include? product.upcase
      puts "#{@row_cells[0]} is #{@row_cells[14]} in Minsk"
      flag = 1
    end
  end
end
flag.zero? && puts("#{product} not faund")
