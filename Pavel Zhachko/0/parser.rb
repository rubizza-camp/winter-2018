# using material from here
# https://spin.atomicobject.com/2017/03/22/parsing-excel-files-ruby/
# https://stackoverflow.com/questions/3321011/parsing-xls-and-xlsx-ms-excel-files-with-ruby
# https://infinum.co/the-capsized-eight/how-to-efficiently-process-large-excel-files-using-ruby
# https://steemit.com/utopian-io/@yuxid/how-to-parse-excel-spreadsheet-in-ruby-via-roo

# try this http://www.belstat.gov.by/upload-belstat/upload-belstat-excel/Oficial_statistika/Average_prices(serv)-10-2018.xlsx
# require 'remote_table'
# r = RemoteTable.new 'http://www.belstat.gov.by/upload-belstat/upload-belstat-excel/Oficial_statistika/Average_prices(serv)-10-2018.xlsx'
# r.each do |row|
#   puts row.inspect
# end

require 'roo'
# initialize in class
xsl = Roo::Spreadsheet.open('data/Average_prices(serv)-10-2018.xlsx')
puts 'What price are you looking for?'
input = gets.chomp

# for find or search method in class (Lvl 1 tast 25% done. I hope.)
xsl.sheets.each do |sheet_name|
  # puts ''
  # puts sheet_name
  # puts '--------------'
  # xsl.each { |elem| puts elem[0] }
  sheet = xsl.sheet(sheet_name)
  result = []
  unless sheet.nil?
    last_row    = sheet.last_row
    last_column = sheet.last_column

    return "Seems no data in sheet: #{sheet_name}" if last_row.nil? && last_column.nil?

    (1..last_row).each do |row|
      (1..last_column).each do |col|
        v = sheet.cell(row, col)
        if sheet.cell(row, 1) =~ /^#{input.upcase}/ && !v.nil?
          result <<
            "#{sheet.cell(row, 1)} is #{sheet.cell(row, 15)} BYN in Minsk these days."
        end
        # if !v.nil?
        #   puts "NIL"
        # else
        #   puts "["+row.to_s+","+col.to_s+"]: " + sheet.cell(row, col).to_s
        # end
      end
    end
  end
  puts result.uniq!
end
