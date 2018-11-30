class PriceSearcher
  def initialize
    @lines=File.read("./data/10-2018.csv").split(/\n/).map do |line|
      line.split(';')
    end
    puts "\nThe price of what product are you looking for?"
    @name=gets.chomp
    @rezult=[]
  end

  def find
    @lines.each do |elem|
      @rezult<<elem if !elem[0].nil? and elem[0].include?(@name.upcase)
    end
    out
    PriceSearcher.new.find if continue?
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

  def continue?
    puts "\nDo you want to find price for anouther product?(Y(y)/N(n)"
    ans=gets
    ans.chomp.downcase=='y' ? true : ans.chomp.downcase=='n' ? false : "Incorrect sign"
  end
end

#--------------------------------------

search=PriceSearcher.new.find


