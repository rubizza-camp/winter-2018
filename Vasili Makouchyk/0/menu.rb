# I just wanted to make Menu class shorter
module Validation
  DATE_OF_DENOMINATION = '6102-60'.freeze

  def validate_users_input(products)
    puts 'What do you want to see?'
    view_all_products(products)
    handle_choice_input(products)
  end

  def handle_choice_input(products)
    loop do
      index_choice = gets.chomp
      index_choice = begin Integer(index_choice)
                     rescue ArgumentError
                       nil
                     end
      return [products[index_choice]] if
        validate_index_choice(index_choice, products.size)

      puts 'Wrong input! Chose again wisely...'
    end
  end

  def validate_index_choice(index_choice, product_count)
    index_choice && index_choice >= 0 && index_choice < product_count
  end

  def convert_outdated_price(price, date)
    begin Float(price.to_s)
    rescue ArgumentError
      nil
    end
    if (date.reverse <=> DATE_OF_DENOMINATION).negative? || (date.reverse <=> DATE_OF_DENOMINATION).zero?
      price /= 10_000.0
    end
    price.round(2)
  end

  def ask_for_input
    puts 'What product are you looking for? (Write EXIT to break)'
    input = gets.chomp.upcase
    input = begin String(input)
            rescue ArgumentError
              nil
            end
    input
  end
end

# Class is used for operating excel data from Belstat
# You need that files to be put into data/ folder
class Menu
  require 'rubyXL'
  include Validation

  LAST_ROW = 359
  FIRST_ROW = 8
  PRICE_CELL_INDEX = 14

  def initialize(previous_files = Dir['data**/*.xlsx'],
                 current_file = 'data/Average_prices(serv)-10-2018.xlsx')
    @files = previous_files
    @current_file = current_file
  end

  def find_product_in_current_file(user_input, file_to_parse = @current_file)
    products = []
    date = get_date_from_file_name(file_to_parse)
    get_first_sheet(file_to_parse).each_with_index do |row, row_index|
      next if row_index > LAST_ROW || row_index < FIRST_ROW

      row.cells.each_with_index do |cell, cell_index|
        next if cell_index.positive?

        add_product_to_array(cell, products, row, user_input, date)
      end
    end
    empty?(products)
  end

  def find_product_in_previous_files(products, files_to_parse = @files)
    files_to_parse.each do |file|
      products += find_product_in_current_file(products[0][0], file)
    end
    products
  end

  def find_products_with_same_price(price, files_to_parse = @files)
    products = []
    files_to_parse.each do |file|
      date = get_date_from_file_name(file)
      sheet = get_first_sheet(file)
      sheet.each_with_index do |row, row_index|
        next if row_index > LAST_ROW || row_index < FIRST_ROW

        find_products_by_price(products, price, date, row)
      end
    end
    products
  end

  def view_products_found(products, min_max_price, with_same_price)
    print_unconditioned_message(products, min_max_price, with_same_price)
    with_same_price.each { |product| puts "#{product[0]} at #{product[1]}" }
  end

  def choose_product_to_show(products)
    return validate_users_input(products) if products.size > 1

    products
  end

  def find_max_min_price_at_date(products)
    prices = []
    max_min_price = []
    products.each { |product| prices.push [product[1], product[2]] }
    max_min_price.push(prices.max_by { |price, _| [price] })
    max_min_price.push(prices.min_by { |price, _| [price] })
    max_min_price
  end

  private

  def print_min_max_price(min_max_price)
    puts "Lowest is #{min_max_price[1][0]} #{min_max_price[1][1]}"
    puts "Highest is #{min_max_price[0][0]} #{min_max_price[0][1]}"
  end

  def print_unconditioned_message(products, min_max_price, with_same_price)
    puts "#{products[0][0]} cost #{products[0][1]} in Minsk #{products[0][2]}"
    print_min_max_price(min_max_price)
    print 'For the same price you could afford '
    puts 'nothing.' if with_same_price[0].nil?
  end

  def add_product_to_array(cell, products, row, user_input, date)
    price = row[PRICE_CELL_INDEX].value.to_s.to_f
    price = convert_outdated_price(price, date)
    products.push([cell.value, price, date]) if
      cell.value.to_s.upcase.include? user_input
  end

  def find_products_by_price(products, price, date, row)
    products.push([row[0].value, date]) if row[PRICE_CELL_INDEX].value == price
  end

  def empty?(products)
    puts 'Nothing is found' if products.empty?
    products
  end

  def view_all_products(products)
    products.each_with_index do |product, p_index|
      puts "#{p_index}: #{product[0]}"
    end
  end

  def get_date_from_file_name(file_name)
    file_name.to_s.reverse[5..11].to_s.reverse!
  end

  def get_first_sheet(file_name)
    book = RubyXL::Parser.parse file_name
    book.worksheets[0]
  end
end
