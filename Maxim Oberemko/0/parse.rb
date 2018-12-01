require "roo"
class PriceSearcher
  def initialize
    @file=Roo::Excelx.new("./data/Average_prices(serv)-10-2018.xlsx")
    puts "\nThe price of what product are you looking for?"
    @name=gets.chomp
    @rezult=[]
  end

  def find
    @file.each do |elem|
      @rezult<<elem if !elem[0].nil? and elem[0]=~/#{@name.upcase}[., )]/ 
    end
    out
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

end

#--------------------------------------

search=PriceSearcher.new.find


