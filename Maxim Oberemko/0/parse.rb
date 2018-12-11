require 'roo'
require 'roo-xls'
MINSK_COL = 14
class PriceSearcher
  def initialize
    @last_table = Roo::Spreadsheet.open('./data/Average_prices(serv)-10-2018.xlsx')
    @name = ''
    @result = []
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
    Dir.glob('./data/*').each { |file| minmax << Roo::Spreadsheet.open(file) }
    minmax.compact
  end

  def out
    @all_tables = all_tables
    @results.each do |product|
      dates, prices = all_prices_for_product(product)
      min = prices.min
      max = prices.max
      out_minmax(min, dates[prices.index(min)], max, dates[prices.index(max)], product)
    end
  end

  def all_prices_for_product(product)
    dates = []
    prices = []
    @all_tables.each do |table|
      k = check_denomination(table)
      dates << convert_date(table)
      table.each do |row|
        prices << (k * row[MINSK_COL]).round(4) if correct_line?(product, row)
      end
    end
    [dates, prices]
  end

  def out_minmax(min, min_dt, max, max_dt, elem)
    el = elem[0].capitalize.gsub(/\s+/, ' ')
    str = "of '#{el}' " if @results.length != 1
    puts "Lowest #{str}was on #{min_dt[0]}/#{min_dt[1]} at #{min} BYN"
    puts "Hightest #{str}was on #{max_dt[0]}/#{max_dt[1]} at #{max} BYN"
  end

  def correct_line?(res, row)
    !row[0].nil? && row[0] == res[0] && !row[14].nil?
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
