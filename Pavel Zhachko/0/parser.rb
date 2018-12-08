# some idea for lvl 3 or check files if there is no data folder.
# try this http://www.belstat.gov.by/upload-belstat/upload-belstat-excel/Oficial_statistika/Average_prices(serv)-10-2018.xlsx
# require 'remote_table'
# r = RemoteTable.new 'http://www.belstat.gov.by/upload-belstat/upload-belstat-excel/Oficial_statistika/Average_prices(serv)-10-2018.xlsx'
# r.each do |row|
#   puts row.inspect
# end

SIMILAR_PRICE = 'For similar price you also can afford \''.freeze
SIMILAR_STRING_NOT_FOUND = 'Similar prices can not be found in database.'.freeze
MONTH = {
  'январь' => '01',
  'февраль' => '02',
  'март' => '03',
  'апрель' => '04',
  'май' => '05',
  'июнь' => '06',
  'июль' => '07',
  'август' => '08',
  'сентябрь' => '09',
  'откябрь' => '10',
  'ноябрь' => '11',
  'декабрь' => '12'
}.freeze

require 'pry'
require 'pry-coolline'
require 'roo'
require 'roo-xls'
# initialize in class
class RooBookParser
  def initialize
    # @xsl = Roo::Spreadsheet.open('data/Average_prices(serv)-10-2018.xlsx')
    # @xsl = Roo::Spreadsheet.open('data/prices_tov_0109.xls', extension: :xls)
    @xsl = check_table_extension('data/prices_tov_0109.xls')
    @date = convert_month_and_year(@xsl)
    @result = []
    @similar_prices = []
    @similar_result = []
    @s_p_result = []
  end

  def check_table_extension(name)
    if /xls$/.match?(name)
      Roo::Spreadsheet.open(name, extension: :xls)
    elsif /.xlsx$/.match?(name)
      Roo::Spreadsheet.open(name, extension: :xlsx)
    end
  end

  def get_month_and_year(filename)
    filename.row(3)[0].split(' ').select { |el| /20[01][0-9]$/.match?(el) || MONTH.key?(el) }
  end

  def convert_month_and_year(filename)
    date = get_month_and_year(filename)
    date[0] = MONTH[date[0]]
    date
  end

  def denomination_check(date)
    if date[1].to_i >= 2017
      'BYN in Minsk these days.'
    elsif date[1].to_i < 2017
      'BYR in Minsk these days.'
    end
  end

  def search_price_by_name(input)
    @result = @xsl.select { |elem| /^#{input.upcase}\b/.match?(elem[0]) }
  end

  def output_parser(prices, input)
    # lvl 1
    return "\'#{input}\' can not be found in database." if prices.empty?

    prices.each do |elem|
      puts "#{elem[0]} is #{elem[14]} " + denomination_check(@date)
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
    end
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

  # def open_xsl_table(path_and_name)
  #   if Dir.exist?('data')
  #     @xsl = Roo::Spreadsheet.open(path_and_name)
  #   else
  #     Dir.mkdir('data')
  #     Dir.chdir('data')
  #   end
  # end
end

r = RooBookParser.new
puts 'What price are you looking for?'
input = gets.chomp
r.output_parser(r.search_price_by_name(input), input)
r.search_similar_price_by_name(input)
