ACTUAL_FILE_URI = 'http://www.belstat.gov.by/upload-belstat/upload-belstat-excel/Oficial_statistika/Average_prices(serv)-10-2018.xlsx'.freeze
ERROE_NO_FILES_TO_CHECK = 'There is no file to check in data folder. So we take actual file from uri.'.freeze
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

class RooBookParser
  def initialize
    @actual_table = Roo::Spreadsheet.open(ACTUAL_FILE_URI)
    @all_files = []
  end

  def check_table_extension(name)
    if /xls$/.match?(name)
      Roo::Spreadsheet.open(name, extension: :xls)
    elsif /.xlsx$/.match?(name)
      Roo::Spreadsheet.open(name, extension: :xlsx)
    end
  end

  def collect_all_files(*)
    Dir.chdir('data') unless Dir.pwd.match?('data')
    FileList.new('*.xls*').map! do |filename|
      check_table_extension(filename)
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
  # def test_temp(name)
  #   # puts ERROE_NO_FILES_TO_CHECK if collect_all_files.empty?
  #   if collect_all_files.empty?
  #     puts ERROE_NO_FILES_TO_CHECK
  #     search_price_by_name(name)
  #   else
  #     collect_all_files.each { |file| search_price_by_name(name, file) }
  #   end
  # end
  #
  # def lvl2_out(name)
  #   prices = test_temp(name)
  #   prices.each { |price| p price }
  # end

  def search_price_by_name(input_name, table = @actual_table)
    table.select { |elem| regexp_template_for_item(input_name).match?(elem[0]) }
  end

  def output_template(array_of_prices, name_of_item)
    puts("\'#{name_of_item}\' can not be found in database.") && return if array_of_prices.empty?
    array_of_prices.each do |elem|
      puts "#{name_of_item} is #{elem[14]} BYN in these days."
    end
  end

  def output_parser(input_name)
    prices =
      if collect_all_files.empty?
        puts ERROE_NO_FILES_TO_CHECK
        search_price_by_name(input_name)
      else
        collect_all_files.each { |file| @all_files << [convert_date(convert_month_and_year(file)), file] }
        search_price_by_name(input_name, @all_files.max_by { |el| el[0] }[1])
      end
    output_template(prices, input_name)
  end
end

r = RooBookParser.new
puts 'What price are you looking for?'
input_name = gets.chomp
# lvl 1
r.output_parser(input_name)
# lvl 2
# r.test_temp(input_name)
# r.lvl2_out(input_name)
