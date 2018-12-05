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
class RooBookParser
  def initialize
    @xsl = Roo::Spreadsheet.open('data/Average_prices(serv)-10-2018.xlsx')
    @result = []
  end

  def output_parser(prices)
    # lvl 1
    prices.each do |elem|
      puts "#{elem[0]} is #{elem[14]} BYN in Minsk these days."
    end
    # lvl 2
    # lvl 3
  end

  def test_search; end

  def search
    puts 'What price are you looking for?'
    input = gets.chomp
    @xsl.each do |elem|
      @result << elem if elem[0] =~ /^#{input.upcase}\b/
    end
    puts "\'#{input}\' can not be found in database." if @result.empty?
    output_parser(@result)
  end
end

r = RooBookParser.new
r.search
