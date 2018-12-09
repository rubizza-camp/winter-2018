require 'roo'
require 'roo-xls'
# require 'rubocop'
xlfilenow = Roo::Excelx.new('./data/Average_prices(serv)-10-2018.xlsx') # Info about prices in Minsk these days
@sheetnow = xlfilenow.sheet(0)
@goods = []
@prices = []
@matched_items = 0
@matched_items_indexes = []
puts 'Enter you desired product name in Russian...'
@product_request = gets.chomp.upcase # Product name input

def main_table_read(sheet)
  # Finding info about all requested items
  (0..354).each do |i|
    next unless !sheet.cell(i + 8, 1).nil? && !sheet.cell(i + 8, 15).nil? # Item in i+8 row has actual name and price

    next unless sheet.cell(i + 8, 1).include? @product_request.to_s # Item's name having requested key word in it

    @goods << sheet.cell(i + 8, 1) # Saving info about items
    @prices << sheet.cell(i + 8, 15)
    @matched_items_indexes << (i + 1)
    @matched_items += 1 # Amount of items which had requested key word in it
    @good_price = @prices[0] # These two will be used for level 3
    @good_name = @goods[0]
  end
end

def date_read(sheet)
             # Read exact cell from requested sheet and generate mm/yyyy date
  date = ''  # Actually need a tip how to make this not so dumb
  date_text = sheet.cell(3, 1)
  if date_text.include? 'январь'
    date += '01'
  elsif date_text.include? 'февраль'
    date += '02'
  elsif date_text.include? 'март'
    date += '03'
  elsif date_text.include? 'апрель'
    date += '04'
  elsif date_text.include? 'май'
    date += '05'
  elsif date_text.include? 'июнь'
    date += '06'
  elsif date_text.include? 'июль'
    date += '07'
  elsif date_text.include? 'август'
    date += '08'
  elsif date_text.include? 'сентябрь'
    date += '09'
  elsif date_text.include? 'октябрь'
    date += '10'
  elsif date_text.include? 'ноябрь'
    date += '11'
  elsif date_text.include? 'декабрь'
    date += '12'
  end

  date += '/'

  if date_text.include? '2009'
    date += '2009'
  elsif date_text.include? '2010'
    date += '2010'
  elsif date_text.include? '2011'
    date += '2011'
  elsif date_text.include? '2012'
    date += '2012'
  elsif date_text.include? '2013'
    date += '2013'
  elsif date_text.include? '2014'
    date += '2014'
  elsif date_text.include? '2015'
    date += '2015'
  elsif date_text.include? '2017'
    date += '2017'
    @notbyn = false # Case to convert BYR to BYN cause all files before year 2017 had prices written in 'before denomination' format
  elsif date_text.include? '2018'
    date += '2018'
    @notbyn = false
  else
    date += if date_text.include? '2016'
              '2016'
            else
              '***** какая то' # Censored testing mechanism
            end
  end
  date # Returning a string
end

def prices_find # Looking through all files for min and max price of the item
  @allfiles = Dir.entries('./data')
  allfiles_length = @allfiles.size
  (0...allfiles_length).each do |i0| # Going through all files in ./data/ directory
    next unless @allfiles[i0] != '.' && @allfiles[i0] != '..' # Ignoring . and .. files

    xlfile = if @allfiles[i0].include? 'xlsx' # To read both .xls and .xlsx files
               Roo::Excelx.new("./data/#{@allfiles[i0]}")
             else
               Roo::Spreadsheet.open("./data/#{@allfiles[i0]}")
             end
    sheet = xlfile.sheet(0) # Pick 1st sheey
    @goods.clear
    @prices.clear
    (0..354).each do |i| # Go though all items
      next unless !sheet.cell(i + 8, 1).nil? && !sheet.cell(i + 8, 15).nil? # Item in i+8 row has actual name and price

      next unless sheet.cell(i + 8, 1).include? @product_request.to_s # Item's name having requested key word in it

      @goods[0] = sheet.cell(i + 8, 1) # Saving info
      @prices[0] = sheet.cell(i + 8, 15)
    end
    @notbyn = true # Switch to know when to convert BYR to BYN.
    date = date_read(sheet) # Read exact cell from requested sheet and generate mm/yyyy date. @notbyn will get FALSE value if year is 2017 or 2018
    next if @prices[0].nil?

    @prices[0] = bynconvert(@prices[0]) if @notbyn # Converting according to the switch(@notbyn) value

      if @prices[0] > @max_price
        @max_price = @prices[0]
        @max_date = date
      end
    next unless @prices[0] < @min_price # A bit(as for me) weird way to write code for looking max and min values, but rubocop knows better...

    @min_price = @prices[0]
    @min_date = date
  end
  puts "Maximal price was #{@max_price.round(2)} BYN on #{@max_date}" # Print results
  puts "Minimal price was #{@min_price.round(2)} BYN on #{@min_date}"
end

def bynconvert(byr)
  # Self-explanatory
  byn = byr
  byn = byr / 10_000 unless byr.nil?
  byn
end

def info_output
  # Print info about found items according to the request key word
  if @matched_items == 0
    puts "Can't find anything matching your request for #{@product_request}."
  elsif @matched_items == 1 && @product_request != @goods[0]
    puts "The only thing matching \'#{@product_request}\' is #{@goods[0]} for #{@prices[0]} BYN"
  elsif @matched_items == 1 && @product_request == @goods[0]
    puts "There is \'#{@goods[0]}\' just for #{@prices[0]} BYN"
  else
    info_list_output # Print several results
  end
end

def info_list_output
  # Print several results
  puts 'There are several matching results just for you, darling :^)'
  matched_length = @matched_items_indexes.size
  (0...matched_length).each do |i|
    puts "#{@matched_items_indexes[i]}) #{@goods[i]} - #{@prices[i]} BYN"
  end
end

def same_price_output
  # Prints list of items with the same cost
  answer = 'You can\'t afford anything else for that price.' # Default answer
  same_length = @same_price_names.size
  if same_length > 0 # Changes answer if anything was found
    answer = 'For the same price you can also buy '
    (0...same_length).each do |i|
      answer += if i + 2 == same_length
                  "#{@same_price_names[i]}\' and "
                elsif i + 1 == same_length
                  "\'#{@same_price_names[i]}\'"
                else
                  "\'#{@same_price_names[i]}\', "
                end
    end
  end
  puts answer # Prints answer
end

def same_price_find
  # Find what you can buy for the same price
  @same_price_names = []

  (0..354).each do |i|
    next unless !@sheetnow.cell(i + 8, 1).nil? && !@sheetnow.cell(i + 8, 15).nil?

    next unless @sheetnow.cell(i + 8, 15) == @good_price && @sheetnow.cell(i + 8, 1) != @good_name # Item costs the same but it isn't itself

    @same_price_names << @sheetnow.cell(i + 8, 1)
  end
end
#~~~~~~~~~~~~~~~~~~~~~Main~code~~~~~~~~~~~~~~~~~~~~
main_table_read(@sheetnow)
info_output # Info about all items matching key word(s)
if @matched_items_indexes.size == 1 # Doing level 2 and level 3 only if 1 item was found
  date = date_read(@sheetnow)
  @max_price = @prices[0]
  @max_date = date
  @min_price = @prices[0]
  @min_date = date
  prices_find
  same_price_find
  same_price_output
end
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
