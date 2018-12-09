require 'roo';

require 'roo-xls';

require './WorkWithData.rb';

funcs = FilesParse{}
months = {
  'январь' => 1,
  'февраль' => 2,
  'март' => 3,
  'апрель' => 4,
  'май' => 5,
  'июнь' => 6,
  'июль' => 7,
  'авуст' => 8,
  'сентябрь' => 9,
  'октябрь' => 10,
  'ноябрь' => 11,
  'декабрь' => 12,
}

regions = ['Brest', 
  'Vitebsk',
  'Gomel', 
  'Grodno', 
  'Minsk', 
  'Minsk Region',
  'Mogilyov']
products = Hash.new
file_Paths =  Dir["./data/*"]

file_Paths.each{ |file_Path|
  file = funcs.get_File(file_Path)

  if file
    funcs.fetch_Products_Data(file, products, regions)
  end
}
loop {
  puts "What price are you looking for?"

  word = gets.chomp.downcase

  keys = funcs.find_Keys(word, products)

  if keys.length == 0
    puts word.capitalize + " can not be found in database"
  else
    keys.each{|key|
      puts ""
      recent_Price_Data = funcs.get_Recent_Price_Data(key, products, months)
      puts key.capitalize + " is " + recent_PriceData["price"].to_s + " BYN in Minsk these days."
      minPrice = funcs.get_Min_Price(products[key])
      puts "Lowest was on " + min_Price["year"] +
      "/" + months[min_Price["month"]].to_s +
      " at price " + min_Price["price"].to_s + " BYN"
      max_Price = funcs.get_Max_Price(products[key])
      puts "Maximum was on " + max_Price["year"] +
      "/" + months[maxPrice["month"]].to_s +
      " at price " + maxPrice["price"].to_s + " BYN";
    }
  end
  puts
}
