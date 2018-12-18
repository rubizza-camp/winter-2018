require_relative 'tableconverter'
ACTUAL_FILE_URI = 'http://www.belstat.gov.by/upload-belstat/upload-belstat-excel/Oficial_statistika/Average_prices(serv)-11-2018.xlsx'.freeze
MINSK_CONSTATN_CELL_COL = 'г. Минск'.freeze

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

  def regexp_template_for_item(name)
    /^#{name.upcase}\b/
  end

  def search_price_by_name(name_of_item, minsk_const, table = @actual_table)
    table.select { |elem| regexp_template_for_item(name_of_item).match?(elem[0]) || name_of_item == elem[0] }
         .map { |price| TableConverter.denomination_convertation(table, price, minsk_const) }
  end

  def search_similar_name_by_price(price_of_item, minsk_const, name_of_item)
    @all_files.sort.max[1].select do |elem|
      ((price_of_item.equal?(elem[minsk_const]) && name_of_item != elem[0]) &&
      !regexp_template_for_item(name_of_item).match?(elem[0]))
    end
  end

  def similar_template(array_of_similar_prices)
    'For similar price you also can afford \'' +
      case array_of_similar_prices.length
      when 1
        "#{array_of_similar_prices[0]}\'."
      when 2
        "#{array_of_similar_prices[0]}\' and \'#{array_of_similar_prices[1]}\'"
      when 3..Float::INFINITY
        array_of_similar_prices[0..array_of_similar_prices.length - 2].join('\', \'') +
        + '\' and ' + "\'#{array_of_similar_prices[-1]}\'."
      end
  end

  def similar_price_out(output)
    output.map! { |el| el[0] = TableConverter.converting_similar_name(el[0]) }
    output.empty? ? puts('There is no items with similar price.') : puts(similar_template(output).to_s)
  end

  def output_template(array_of_prices, name_of_item, minsk_const)
    puts("\'#{name_of_item}\' can not be found in database.") && return if array_of_prices.empty?
    array_of_prices.each do |elem|
      puts "\'#{name_of_item}\' is #{elem[minsk_const].round(2)} BYN in these days."
      if @all_files.empty?
        puts 'Put some data files if you wanna see prices by previous years'
      else
        min_max_prices_out(elem[0])
        similar_price_out(search_similar_name_by_price(elem[minsk_const], minsk_const, name_of_item))
      end
    end
  end

  def min_max_value(array)
    [
      [array.min_by { |el| el[1] }[0], array.min_by { |el| el[1] }[1]],
      [array.max_by { |el| el[1] }[0], array.max_by { |el| el[1] }[1]]
    ]
  end

  def min_max_template(name, table)
    [table[0], search_price_by_name(name, minsk_cell(table[1]), table[1]).flatten[minsk_cell(table[1])]]
  end

  def min_max_prices(name)
    array = []
    @all_files.sort.each do |table|
      next if search_price_by_name(name, minsk_cell(table[1]), table[1]).empty?

      array << min_max_template(name, table)
    end
    min_max_value(array)
  end

  def min_max_prices_out(name)
    puts "Lowest was on #{min_max_prices(name)[0][0]} at price #{min_max_prices(name)[0][1]} BYN"
    puts "Maximum was on #{min_max_prices(name)[1][0]} at price #{min_max_prices(name)[1][1]} BYN"
  end

  def minsk_cell(filename)
    filename.row(7).index(MINSK_CONSTATN_CELL_COL)
  end

  def all_max_by
    @all_files.max_by { |el| el[0] }
  end

  def actual_template(input_name)
    [search_price_by_name(input_name, all_max_by[2], all_max_by[1]), all_max_by[2]]
  end

  def actual_price_check(input_name)
    if collect_all_files.empty?
      puts 'There is no file to check in data folder. So we take actual file from uri.'
      search_price_by_name(input_name, minsk_cell(@actual_table))
    else
      collect_all_files.each { |file| @all_files << [TableConverter.convert_month_and_year(file), file, minsk_cell(file)] }
      actual_template(input_name)
    end
  end

  def output_parser(input_name)
    prices, const = actual_price_check(input_name)
    output_template(prices, input_name, const)
  end
end

r = RooBookParser.new
puts 'What price are you looking for?'
input_name = gets.chomp
r.output_parser(input_name)
