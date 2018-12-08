require 'roo'
require 'roo-xls'
# rubocop:disable Layout/Tab
# rubocop:disable Layout/SpaceAfterComma
# rubocop:disable Layout/AlignParameters
# rubocop:disable Naming/VariableNumber
# rubocop:disable Layout/IndentationConsistency
# rubocop:disable Layout/IndentationWidth
# rubocop:disable Metrics/MethodLength
# rubocop:disable Lint/UnneededCopDisableDirective
# rubocop:disable Metrics/ParameterLists
# rubocop:disable Lint/Loop
# rubocop:disable Layout/EmptyLineAfterGuardClause
# comment
# This method smells of :reek:Attribute
# This method smells of :reek:InstanceVariableAssumption
# This method smells of :reek:TooManyInstanceVariables
# This method smells of :reek:UncommunicativeVariableName
class Obekt
  attr_accessor :price
  attr_accessor :lok
  attr_accessor :tab
  attr_accessor :col
  attr_accessor :min
  attr_accessor :max

  # This method smells of :reek:LongParameterList
  # This method smells of :reek:UncommunicativeParameterName
  def initialize(yar_d = 0, yar_e = 9, month_d = 0,
	month_e = 1, flag = ' ', flag_1 = 'nil', per = '', cost = '', log = '',
	tab = '', price = '', max = 0, min = 0)
	  @yar_d = yar_d
	  @month_d = month_d
	  @yar_e = yar_e
	  @month_e = month_e
	  @flag = flag
	  @per = per
	  @cost = cost
	  @log = log
	  @tab = tab
		@price = price
	  @flag_1 = flag_1
	  @max = max
	  @min = min
	 end

  # This method smells of :reek:TooManyStatements
  # This method smells of :reek:NilCheck
	 def screach_today(output)
	  @log = './HomeWork0/prices_tov_1018.xlsx'
	  @tab = Roo::Spreadsheet.open(@log)
	  @col = 9
	  begin
		  @price = @tab.cell(@col + 1,'A')
		  @per = @tab.cell(@col,'A')
	    @cost = @tab.cell(@col,'O')
	    @flag_1 = @per.to_s.include? output
	    if @flag_1
		    puts "#{output} is #{@cost} BYN"
			  break
		   end
		  @col += 1
	  end until @per.nil? && @price.nil?
	   puts "Sorry I can't find it" unless @flag_1
	 end
end
lol = Obekt.new
begin
  puts 'What price are you looking for or press 1 to close?'
  lol.price = gets.chomp
  break if lol.price == '1'
  puts 'There is no input her!' if lol.price.empty?

  lol.screach_today(lol.price.upcase)
end until lol.price != 1
# rubocop:enable  Layout/Tab
# rubocop:enable Layout/SpaceAfterComma
# rubocop:enable Layout/AlignParameters
# rubocop:enable Naming/VariableNumber
# rubocop:enable Layout/IndentationConsistency
# rubocop:enable Layout/IndentationWidth
# rubocop:enable Metrics/MethodLength
# rubocop:enable Lint/UnneededCopDisableDirective
# rubocop:enable Metrics/ParameterLists
# rubocop:enable Lint/Loop
# rubocop:enable Layout/EmptyLineAfterGuardClause
