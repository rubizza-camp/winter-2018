require 'rubyXL'

class Menu

  def initialize(previous_files = ['data/Average_prices(serv)-09-2018.xlsx','data/Average_prices(serv)-08-2018.xlsx'],
                 current_file = 'data/Average_prices(serv)-10-2018.xlsx',)
    @files = previous_files
    @current_file = current_file
  end

  def ask_for_input
    puts 'What product are you looking for? (Wright EXIT to break)'
    input = gets.chomp!
    input.to_s
  end

  def find_product_in_current_file(user_input, file_to_parse = @current_file)
    user_input.upcase!
    products = []

    date = file_to_parse.to_s.reverse[5..11]
    sheet = get_first_sheet(file_to_parse)
    sheet.each_with_index do |row, row_index|
      next if row_index > 359 || row_index < 8

      row.cells.each_with_index do |cell, cell_index|
        next if cell_index > 0

        if (cell.value.to_s.upcase).include? user_input
          products.push([cell&.value, row[14]&.value, date.to_s.reverse])
        end
      end
    end
    if products.empty?
      puts "Nothing is found:("
    end
    products
  end

  def find_product_in_previous_files(products, files_to_parce = @files)
    files_to_parce.each do |file|
      products += find_product_in_current_file(products[0][0], file)
    end
    products
  end

  def find_products_with_same_prise(price, files_to_parce = @files)
    products = []
    files_to_parce.each do |file|
      date = file.to_s.reverse[5..11]
      sheet = get_first_sheet(file)
      sheet.each_with_index do |row, row_index|
        next if row_index > 359 || row_index < 8

        if row[14].value == price
          products.push([row[0].value, date.to_s.reverse])
        end
      end
    end
    products
  end

  def view_products_found(products, min_max_price, products_with_same_price)
    puts "#{products[0][0]} cost #{products[0][1]} in Minsk at #{products[0][2]}"
    puts "Lowest is #{min_max_price[1][0]} at #{min_max_price[1][1]}"
    puts "Highest is #{min_max_price[0][0]} at #{min_max_price[0][1]}"
    print "For the same prise you could afford "
    products_with_same_price.each { |product| print "#{product[0]} at #{product[1]}\n"}
  end

  def choose_product_to_show(products)
    if products.size > 1
      puts "What do you want to see?"
      products.each_with_index {|product, p_index| puts "#{p_index}: #{product[0]}"}

      loop do
        index_choice = gets.chomp!
        if index_choice.to_s.to_i < 0 || index_choice.to_s.to_i >= products.size
          puts "Wrong input! Chose again wisely..."
        else
          return [products[index_choice.to_s.to_i]]
        end
      end
    end
    products
  end

  def find_max_min_price_at_date(products)
    prices = []
    max_min_price = []
    products.each {|product| prices.push [product[1], product[2]]}
    prices.sort_by!
    max_min_price.push prices.first
    max_min_price.push prices.last
    max_min_price
  end

  private

  def get_first_sheet(file_name)
    book = RubyXL::Parser::parse file_name
    book.worksheets[0]
  end

end
