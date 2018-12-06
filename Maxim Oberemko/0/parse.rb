require 'roo'
require 'roo-xls'
MINSK_COL = 14
class PriceSearcher
  def initialize
    @last_table = Roo::Excelx.new('./data/Average_prices(serv)-10-2018.xlsx')
    @name = ''
    @result = @minmax = []
    @similar = {}
  end

  def input_name
    puts "\nThe price of what product are you looking for?"
    @name = gets.chomp
  end

  def find_price
    name = input_name.upcase
    @last_table.select { |el| !el[0].nil? && (el[0] =~ /#{name}[., )]{1}/ || el[0] == name) }.each do |elem|
      @result << elem
    end
  end

  def parse_results
    find_price
    out_price
    return if @result.empty?

    MinMax.new(@result, @name, @last_table).out
    search_similar_price_elems
    out_similar
  end

  def out_price
    case @result.length
    when 0 then
      puts "'#{@name}' can not be found in database."
    when 1 then
      puts "'#{@name}' is #{@result[0][MINSK_COL]} BYN in Minsk these days."
    else
      @result.each do |elem|
        puts "'#{@name}'(#{elem[0].capitalize.gsub(/\s+/, ' ')}) is #{elem[MINSK_COL]} BYN in Minsk these days."
      end
    end
  end

  def search_similar_price_elems
    @result.each do |res|
      @similar[res[0].to_sym] = []
      @last_table.each do |elem|
        @similar[res[0].to_sym] << elem if elem[MINSK_COL].to_f != 0 && similar?(elem, res)
      end
    end
  end

  def similar?(elem, res)
    elem[MINSK_COL].to_f > res[MINSK_COL] - 0.25 && elem[MINSK_COL].to_f < res[MINSK_COL] + 0.25
  end

  def out_similar
    if @result.length == 1
      puts "For similar price you also can afford #{similar_elements(@similar[@similar.keys[0]])}."
    else
      @similar.each do |key, value|
        puts "For similar price as '#{key.to_s.capitalize.gsub(/\s+/, ' ')}'\
you also can afford #{similar_elements(value)}."
      end
    end
  end

  def similar_elements(similar)
    out = ''
    similar.each do |sim|
      if sim[0].match?(/#{@name.upcase}[., )]{1}/) || sim[0] == @name.upcase
        similar.delete_at(similar.index(sim))
        next
      end
      out += "'#{sim[0].capitalize.gsub(/\s+/, ' ')}'" + ','
    end
    out[0...-1]
  end
end

class MinMax
  def initialize(results, name, last_table)
    @results = results
    @all_tables = []
    @name = name
    @last_table = last_table
  end

  def all_tables
    minmax = []
    Dir.foreach('./data') do |file|
      case File.extname(file)
      when '.xlsx' then
        minmax << Roo::Excelx.new("./data/#{file}")
      when '.xls' then
        minmax << Roo::Excel.new("./data/#{file}")
      end
    end
    minmax.compact
  end

  def out
    @all_tables = all_tables
    @results.each do |res|
      out_minmax(min_price(res), max_price(res), res)
    end
  end

  def min_price(res)
    min = convert_date(@last_table) << res[MINSK_COL]
    @all_tables.each do |table|
      k = check_denomination(table)
      table.each do |row|
        min = convert_date(table) << (k * row[MINSK_COL]).round(4) if correct_line?(res, row) && check_min(row, min, k)
      end
    end
    min
  end

  def max_price(res)
    max = convert_date(@last_table) << res[MINSK_COL]
    @all_tables.each do |table|
      k = check_denomination(table)
      table.each do |row|
        max = convert_date(table) << (k * row[MINSK_COL]).round(4) if correct_line?(res, row) && check_max(row, max, k)
      end
    end
    max
  end

  def out_minmax(min, max, elem)
    el = elem[0].capitalize.gsub(/\s+/, ' ')
    str = "of '#{el}' " if @results.length != 1
    puts "Lowest #{str}was on #{min[0]}/#{min[1]} at #{min[2]} BYN"
    puts "Hightest #{str}was on #{max[0]}/#{max[1]} at #{max[2]} BYN"
  end

  def correct_line?(res, row)
    !row[0].nil? && row[0] == res[0]
  end

  def check_min(row, min, coefficient)
    !row[14].nil? && coefficient * row[MINSK_COL] < min[2]
  end

  def check_max(row, max, coefficient)
    !row[14].nil? && coefficient * row[MINSK_COL] > max[2]
  end

  def convert_date(table)
    dates = {
      'январь': '01', 'февраль': '02', 'март': '03', 'апрель': '04',
      'май': '05', 'июнь': '06', 'июль': '07', 'август': '08',
      'сентябрь': '09', 'октябрь': '10', 'ноябрь': '11', 'декабрь': '12'
    }
    date = table.row(3)[0].split(' ')[1..2]
    date[0] = dates[date[0].to_sym]
    date
  end

  def check_denomination(table)
    date = convert_date(table)
    date[1].to_i < 2017 ? 0.0001 : 1
  end
end

PriceSearcher.new.parse_results
