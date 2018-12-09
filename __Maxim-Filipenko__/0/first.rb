require 'roo'

# Class of finding products
class Finder
  def initialize
    @a = Roo::Spreadsheet.open 'file1.xlsx'
    @answer = gets.chomp.upcase
    @result = []
  end

  def making_a_product_list
    @array1 = @a.sheet(0).column(1)
    @array2 = @a.sheet(0).column(15)
    @list = {}

    (0...@array1.length).each do |i|
      @list.store(@array1[i], @array2[i])
    end
    @list.delete_if { |_k, v| v.nil? }
  end

  def searcher
    making_a_product_list
    @list.each do |k, v|
      @result.push("The #{k} is #{v} BYN in Minsk these days") if k.to_s.include? @answer
    end
    puts @result
    print "#{@answer} can not be found in our  data base !" if @result[0].nil?
  end
end

puts 'What product do you need ?'
Finder.new.searcher
