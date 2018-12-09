require 'roo'
require 'roo-xls'
require 'pry'

class Parser
  def parsing_xlsx(name)
    @xlsx = Roo::Spreadsheet.open("./data/#{name}.xlsx")
  end

  def make_hash(file)
    names = file.column(1).drop(7)
    costs = file.column(15).drop(7)
    hash = names.zip(costs).to_h
    hash.delete_if { |_key, value| value.nil? }
  end

  def search(hash)
    puts 'What price are you looking for?'
    arg = gets.chomp
    compare = hash.select { |item| item.include?(arg.upcase) }
    if compare == {}
      puts "#{arg} can not be found in database"
    else
      compare.each { |out| puts "#{out.join(' ')} BYN in Minsk these days." }
    end
  end

  def all_files
    @tables = []
    @tables.push(@xlsx)
    Dir.foreach('./data') do |file|
      extenion = File.extname("#{file}.to_s")
      case extenion
      when '.xlsx'
        @tables.push(Roo::Spreadsheet.open("./data/#{file}", extension: :xlsx))
      when '.xls'
        @tables.push(Roo::Spreadsheet.open("./data/#{file}", extension: :xls))
      end
    end
    @tables
  end

  def format
    @tables.map! { |table| make_hash(table) }
    @tables
  end

  def denomination
    den = 0.0001
    @tables.each do |cost|
      cost.values.inspect.map { |elem| den * elem.to_i } if cost.values[6].to_i > 100
    end
    @tables
  end
end

task = Parser.new
file = task.parsing_xlsx('Average_prices(serv)-01-2018')
hash = task.make_hash(file)
task.search(hash)
