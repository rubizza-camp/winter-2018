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

SIMILAR_PRICE = 'For similar price you also can afford \''.freeze
SIMILAR_STRING_NOT_FOUND = 'Similar prices can not be found in database.'.freeze

require 'pry'
require 'pry-coolline'
require 'roo'
# initialize in class
class RooBookParser
  def initialize
    @xsl = Roo::Spreadsheet.open('data/Average_prices(serv)-10-2018.xlsx')
    @result = []
    @similar_prices = []
    @similar_result = []
    @s_p_result = []
  end

  def search_price_by_name(input)
    @result = @xsl.select { |elem| /^#{input.upcase}\b/.match?(elem[0]) }
  end

  def output_parser(prices, input)
    # lvl 1
    return "\'#{input}\' can not be found in database." if prices.empty?

    prices.each do |elem|
      puts "#{elem[0]} is #{elem[14]} BYN in Minsk these days."
    end
    # lvl 2
    # prices.each do |elem2|
    # end
    # lvl 3
  end

  def test_search; end

  def converting_similar_name(elem)
    elem.split(' ').select { |el| el =~ /[[:upper:]]+/ }.join(' ').downcase
  end

  def search_similar_price_by_value(cell, price_value)
    price_value.each do |sim_price|
      @s_p_result = converting_similar_name(cell[0]) if cell.include?(sim_price)
    end
    @s_p_result
  end

  def search_similar_price_by_name(name)
    @similar_prices = search_price_by_name(name).collect { |elem| elem[14] }
    @xsl.each do |elem2|
      next unless /^#{name.upcase}\b/.match?(elem2[0])

      @similar_result << search_similar_price_by_value(elem2, @similar_prices)
      # @similar_prices.each do |sim_price|
      #   @similar_result << converting_similar_name(elem2[0]) if elem2.include?(sim_price)
      # end
    end
    # p "#{@similar_result} v1"
    @similar_result.empty? ? puts(SIMILAR_STRING_NOT_FOUND) : similar_prices_output(@similar_result)
  end

  # lvl 3
  def similar_prices_output(similar)
    out_string =
      case similar.length
      when 1
        "\'#{similar[0]}\'."
      when 2
        "\'#{similar[0]}\' and \'#{similar[1]}\'"
      when 3..Float::INFINITY
        similar[0..similar.length - 2].join('\', \'') + '\' and ' + "\'#{similar[-1]}\'."
      end
    puts SIMILAR_PRICE + out_string
  end
end

r = RooBookParser.new
puts 'What price are you looking for?'
input = gets.chomp
r.output_parser(r.search_price_by_name(input), input)
r.search_similar_price_by_name(input)
