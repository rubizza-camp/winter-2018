#!/usr/bin/env ruby
ACTUAL_FILE_URI = 'http://www.belstat.gov.by/upload-belstat/upload-belstat-excel/Oficial_statistika/Average_prices(serv)-10-2018.xlsx'.freeze
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
  'октябрь' => '10',
  'ноябрь' => '11',
  'декабрь' => '12'
}.freeze

require 'rake'
require 'roo'
require 'roo-xls'
# initialize in class
class RooBookParser
  def initialize
    @actual_table = Roo::Spreadsheet.open(ACTUAL_FILE_URI)
  end

  def search_price_by_name(input_name)
    @actual_table.select { |elem| /^#{input_name.upcase}\b/.match?(elem[0]) }
  end

  def output_parser(input_name)
    prices = search_price_by_name(input_name)
    puts("\'#{input_name}\' can not be found in database.") && return if prices.empty?
    prices.each do |elem|
      puts "#{input_name} is #{elem[14]} BYN in these days."
    end
  end
end

r = RooBookParser.new
puts 'What price are you looking for?'
input_name = gets.chomp
# lvl 1
r.output_parser(input_name)
