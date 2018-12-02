require 'roo'
require 'roo-xls'
class PriceSearcher
  def initialize
    @last_table = Roo::Excelx.new('./data/Average_prices(serv)-10-2018.xlsx')
    puts "\nThe price of what product are you looking for?"
    @name = gets.chomp
    @rezult = []
    @minmax = []
  end

  def find
    @last_table.each do |elem|
      @rezult << elem if !elem[0].nil? && elem[0] =~ /#{@name.upcase}[., )]{1}/
    end
    out
    MinMax.new(@rezult, @name, @last_table).out && similar_price unless @rezult.empty?
  end

  def out
    case @rezult.length
    when 0 then
      puts "'#{@name}' can not be found in database."
    when 1 then
      puts "'#{@name}' is #{@rezult[0][14]} BYN in Minsk these days."
    else
      @rezult.each do |elem|
        puts "'#{@name}'(#{elem[0].capitalize.gsub(/\s+/, ' ')}) is #{elem[14]} BYN in Minsk these days."
      end
    end
  end

  def similar_price
    @rezult.each do |rez|
      similar = []
      @last_table.each do |elem|
        case elem[14].to_f
        when rez[14] - 0.25..rez[14] + 0.25 then
          similar << elem if elem[14].to_f != 0
        end
      end
      out_similar(rez, similar)
    end
  end

  def out_similar(rez, similar)
    if @rezult.length == 1
      puts "For similar price you also can afford #{similar_elements(similar)}."
    elsif @rezult.length > 1
      puts "For similar price as '#{rez[0].capitalize.gsub(/\s+/, ' ')}'\
you also can afford #{similar_elements(similar)}."
    end
  end

  def similar_elements(similar)
    out = ''
    similar.each do |sim|
      similar.delete_at(similar.index(sim)) && next if sim[0] =~ /#{@name.upcase}[., )]/
      out += "'#{sim[0].capitalize.gsub(/\s+/, ' ')}'" + ','
    end
    out[0...-1]
  end
end

class MinMax
  def initialize(rezults, name, last_table)
    @rezults = rezults
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
    @rezults.each do |rez|
      out_minmax(find_min(rez), find_max(rez), rez)
    end
  end

  def find_min(rez)
    min = convert_date(@last_table) << rez[14]
    @all_tables.each do |table|
      k = check_denomination(table)
      table.each do |row|
        min = convert_date(table) << (k * row[14]).round(4) if correct_line?(rez, row) && check_min(row, min, k)
      end
    end
    min
  end

  def find_max(rez)
    max = convert_date(@last_table) << rez[14]
    @all_tables.each do |table|
      k = check_denomination(table)
      table.each do |row|
        max = convert_date(table) << (k * row[14]).round(4) if correct_line?(rez, row) && check_max(row, max, k)
      end
    end
    max
  end

  def out_minmax(min, max, elem)
    el = elem[0].capitalize.gsub(/\s+/, ' ')
    str = "of '#{el}' " if @rezults.length != 1
    puts "Lowest #{str}was on #{min[0]}/#{min[1]} at #{min[2]} BYN"
    puts "Hightest #{str}was on #{max[0]}/#{max[1]} at #{max[2]} BYN"
  end

  def correct_line?(rez, row)
    !row[0].nil? && row[0] == rez[0]
  end

  def check_min(row, min, coefficient)
    !row[14].nil? && coefficient * row[14] < min[2]
  end

  def check_max(row, max, coefficient)
    !row[14].nil? && coefficient * row[14] > max[2]
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

PriceSearcher.new.find
