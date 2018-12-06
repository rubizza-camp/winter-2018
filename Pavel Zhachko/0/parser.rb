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
    @similar_price = []
    @similar_result = []
  end

  def output_parser(prices)
    # lvl 1
    prices.each do |elem|
      puts "#{elem[0]} is #{elem[14]} BYN in Minsk these days."
    end
    # lvl 2
    # lvl 3
    prices.each do |elem2|
    end
  end

  def test_search; end

  def search_similr_price(price, name)
    @xsl.each do |elem2|
      unless elem2[0] =~ /^#{name.upcase}\b/
        price.each do |sim_price|
          @similar_result << elem2[0]
                             .split(' ')
                             .select { |el| el =~ /[[:upper:]]+/ }
                             .join(' ').downcase if elem2.include?(sim_price)
        end
      end
    end
    puts 'Similar prices can not be found in database.' if @similar_result.empty?
    similar_output(@similar_result)
  end

  def similar_output(similar)
    # p similar
    # similar.map! do |s|
    #   s.split(' ').select { |el| el =~ /[[:upper:]]+/ }.join(' ').downcase
    # end
    if similar.length == 2
      puts "For similar price you also can afford \'#{similar[0]}\' and \'#{similar[1]}\'"
    elsif similar.length >= 3
      puts 'For similar price you also can afford \'' + similar[0..similar.length - 2].join('\', \'') +
           + '\' and ' + "\'#{similar[-1]}\'"
    else
      puts 'Something wrong'
    end
  end

  def search_price_by_name
    puts 'What price are you looking for?'
    input = gets.chomp
    @xsl.each do |elem|
      if elem[0] =~ /^#{input.upcase}\b/
        @result << elem
        @similar_price << elem[14]
      end
    end
    puts "\'#{input}\' can not be found in database." if @result.empty?
    output_parser(@result)
    search_similr_price(@similar_price, input)
  end
end

r = RooBookParser.new
r.search_price_by_name
