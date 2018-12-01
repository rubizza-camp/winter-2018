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
      @rezult<<elem if !elem[0].nil? and elem[0]=~/#{@name.upcase}[., )]/ 
    end
    out
    min_max if @rezult.length!=0
  end

  def out
    case @rezult.length
    when 0 then
      puts "'#{@name}' can not be found in database."
    when 1 then
      puts "'#{@name}' is #{@rezult[0][14]} BYN in Minsk these days."
    else
      @rezult.each do |elem|
        puts "'#{@name}'(#{elem[0].capitalize}) is #{elem[14]} BYN in Minsk these days."
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
      puts "Lowest of #{elem[0].capitalize} was on #{min_date[0]}/#{min_date[1]} at #{min} BYN"
      puts "Hightest of #{elem[0].capitalize} was on #{max_date[0]}/#{max_date[1]} at #{max} BYN"
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
    true if date[1].to_i<2017
  end

end

#--------------------------------------

search=PriceSearcher.new.find



