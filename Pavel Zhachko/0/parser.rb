require 'rake'
require 'roo'
require 'roo-xls'
MINSK_CONSTATN_CELL_COL = 14
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

class RooBookParser
  def initialize
    @actual_table = Roo::Spreadsheet.open(ACTUAL_FILE_URI)
    @all_files = []
  end

  def collect_all_files
    Dir.chdir('data') unless Dir.pwd.match?('data')
    FileList.new('*.xls*').map do |filename|
      Roo::Spreadsheet.open(filename)
    end
  end

  def get_month_and_year(filename)
    filename.row(3)[0].split(' ').select { |el| /20[01][0-9]$/.match?(el) || MONTH.key?(el) }
  end

  def convert_month_and_year(filename)
    date = get_month_and_year(filename)
    date[0] = MONTH[date[0]]
    date.reverse
  end

  def regexp_template_for_item(name)
    /^#{name.upcase}\b/
  end

  def convert_date(array)
    array.join('/')
  end

  def search_price_by_name(name_of_item, table = @actual_table)
    table.select { |elem| regexp_template_for_item(name_of_item).match?(elem[0]) || name_of_item == elem[0] }
  end

  def output_template(array_of_prices, name_of_item)
    puts("\'#{name_of_item}\' can not be found in database.") && return if array_of_prices.empty?
    array_of_prices.each do |elem|
      puts "#{name_of_item} is #{elem[MINSK_CONSTATN_CELL_COL]} BYN in these days."
      lvl_2_out(elem[0])
    end
  end

  def denomination_convertation(template)
    # code for prices before 2017/01
  end

  def min_max_sort(array)
    [
      [array.min_by { |el| el[1] }[0], array.min_by { |el| el[1] }[1]],
      [array.max_by { |el| el[1] }[0], array.max_by { |el| el[1] }[1]]
    ]
  end

  def lvl_2(name)
    arr = []
    puts 'Put some data files if you wanna see prices by previous years' && return if @all_files.empty?
    @all_files.sort.each do |table|
      next if search_price_by_name(name, table[1]).empty?

      arr << [table[0], search_price_by_name(name, table[1]).flatten[MINSK_CONSTATN_CELL_COL]]
    end
    min_max_sort(arr)
  end

  def lvl_2_out(name)
    puts "Lowest was on #{lvl_2(name)[0][0]} at price #{lvl_2(name)[0][1]} BYN"
    puts "Maximum was on #{lvl_2(name)[1][0]} at price #{lvl_2(name)[1][1]} BYN"
  end

  def lvl_1(input_name)
    if collect_all_files.empty?
      puts 'There is no file to check in data folder. So we take actual file from uri.'
      search_price_by_name(input_name)
    else
      collect_all_files.each { |file| @all_files << [convert_date(convert_month_and_year(file)), file] }
      search_price_by_name(input_name, @all_files.max_by { |el| el[0] }[1])
    end
  end

  def output_parser(input_name)
    prices = lvl_1(input_name)
    output_template(prices, input_name)
  end
end

r = RooBookParser.new
puts 'What price are you looking for?'
input_name = gets.chomp
r.output_parser(input_name)
