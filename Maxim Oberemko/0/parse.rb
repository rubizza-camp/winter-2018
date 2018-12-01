require "roo"
require "roo-xls"
class PriceSearcher
  def initialize
    @last_table=Roo::Excelx.new("./data/Average_prices(serv)-10-2018.xlsx")
    puts "\nThe price of what product are you looking for?"
    @name=gets.chomp
    @rezult=[]
    @minmax=[]
  end

  def find
    @last_table.each do |elem|
      @rezult<<elem if !elem[0].nil? and elem[0]=~/#{@name.upcase}[., )]{1}/ 
    end
    out
    if @rezult.length!=0
      min_max 
      similar_price
    end
  end

  def out
    case @rezult.length
    when 0 then
      puts "'#{@name}' can not be found in database."
    when 1 then
      puts "'#{@name}' is #{@rezult[0][14]} BYN in Minsk these days."
    else
      @rezult.each do |elem|
        puts "'#{@name}'(#{elem[0].capitalize.gsub(/\s+/, " ")}) is #{elem[14]} BYN in Minsk these days."
      end
    end
  end

  def min_max
    get_all_tables
    @rezult.each do |elem|
      min=max=elem[14]
      min_date=max_date=get_date(@last_table)
      @minmax.each do |table|
        check_denomination(table) ? k=0.0001 : k=1
        table.each do |row|
          if !row[0].nil? and row[0]==elem[0]
            min=(k*row[14]).round(4) and min_date=get_date(table) if !row[14].nil? and k*row[14]<min
            max=(k*row[14]).round(4) and max_date=get_date(table) if !row[14].nil? and k*row[14]>max
          end
        end
      end
      out_minmax(min_date,max_date,min,max,elem)
    end   
  end

  def get_all_tables
    Dir.foreach("./data") do |file|
      case File.extname(file)
      when ".xlsx" then
        @minmax<<Roo::Excelx.new("./data/#{file}")
      when ".xls" then
        @minmax<<Roo::Excel.new("./data/#{file}")
      end
    end
    @minmax.compact
  end

  def out_minmax(min_date,max_date,min,max,elem)
    if @rezult.length==1
      puts "Lowest was on #{min_date[0]}/#{min_date[1]} at #{min} BYN"
      puts "Hightest was on #{max_date[0]}/#{max_date[1]} at #{max} BYN"
    elsif @rezult.length>1      
      puts "Lowest of '#{elem[0].capitalize.gsub(/\s+/, " ")}' was on #{min_date[0]}/#{min_date[1]} at #{min} BYN"
      puts "Hightest of '#{elem[0].capitalize.gsub(/\s+/, " ")}' was on #{max_date[0]}/#{max_date[1]} at #{max} BYN"
    end  
  end

  def get_date(table)
    dates={
      "январь": "01",
      "февраль": "02",
      "март": "03",
      "апрель": "04",
      "май": "05",
      "июнь": "06",
      "июль": "07",
      "август": "08",
      "сентябрь": "09",
      "октябрь": "10",
      "ноябрь": "11",
      "декабрь": "12",
    }
    date=table.row(3)[0].split(' ')[1..2]
    date[0]=dates[date[0].to_sym]
    date
  end

  def check_denomination(table)
    date=get_date(table)
    true if date[1].to_i < 2017
  end

  def similar_price
    @rezult.each do |rez|
      similar = []
      @last_table.each do |elem|
        unless elem[14].nil?
          case elem[14].to_f
          when rez[14] - 0.25..rez[14] + 0.25 then
            similar << elem if elem[14].to_f != 0
          end
        end
      end
      out_similar(rez, similar)
    end
  end

  def out_similar(rez, similar)
    if @rezult.length == 1
      puts "For similar price you also can afford #{similar_elements(similar)}."
    elsif @rezult.length > 1
      puts "For similar price as '#{rez[0].capitalize.gsub(/\s+/, ' ')}' you also can afford #{similar_elements(similar)}."
    end  
  end

  def similar_elements(similar)
    out= ''
    similar.each do |sim|
      similar.delete_at(similar.index(sim)) && next if sim[0] =~ /#{@name.upcase}[., )]/
      out += "'#{sim[0].capitalize.gsub(/\s+/, ' ')}'" + ','
    end
    out[0...-1]
  end
end

PriceSearcher.new.find