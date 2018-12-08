require 'roo';

require 'roo-xls';

require './WorkWithData.rb';

funcs = FilesParse.new;
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
filePaths =  Dir["./data/*"]

filePaths.each{ |filePath|
  fileInstance = funcs.getFile(filePath)

  if fileInstance
    funcs.fetchProductsData(fileInstance, products, regions)
  end
}
loop {
  puts "What price are you looking for?"

  word = gets.chomp.downcase;

  keys = funcs.findKeys(word, products);

  if keys.length == 0
    puts word.capitalize + " can not be found in database"
  else
    keys.each{|key|
      puts ""
      recentPriceData = funcs.getRecentPriceData(key, products, months)
      puts key.capitalize + " is " + recentPriceData["price"].to_s + " BYN in Minsk these days."
      minPrice = funcs.getMinPrice(products[key])
      puts "Lowest was on " + minPrice["year"] +
      "/" + months[minPrice["month"]].to_s +
      " at price " + minPrice["price"].to_s + " BYN"
      maxPrice = funcs.getMaxPrice(products[key])
      puts "Maximum was on " + maxPrice["year"] +
      "/" + months[maxPrice["month"]].to_s +
      " at price " + maxPrice["price"].to_s + " BYN";
    }
    
  end
  puts;
}