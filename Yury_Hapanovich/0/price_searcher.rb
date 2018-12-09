require 'roo'
require 'roo-xls'
require './min_max_searcher'
require './region_setter'

# Main class of this app.
class PriceSearcher
  REGIONS_COLOMNS_LINK = { 'Рб' => 'E', 'Брестская' => 'G', 'Витебская' => 'I',
                           'Гомельская' => 'K', 'Гродненская' => 'M',
                           'Минск' => 'O', 'Минская' => 'Q',
                           'Могилёвская' => 'S' }.freeze
  FIRST_PRODUCT_ROW = 9

  def initialize
    @current_region = 'Минск'
    puts "Current region is #{@current_region}. Select another? (y/n)"
    if %w[y Y д Д].include?(gets.chomp)
      @current_region = RegionSelector.new(REGIONS_COLOMNS_LINK).select_region
      puts "Current region is #{@current_region}"
    end
    @products = {} # {product => [price, min, min_date, max, max_date]}
    @request = ''
    @last_file = Dir['./data/*'].max
    @similar = {}
  end

  def analyze
    @request = input_request
    table = Roo::Spreadsheet.open(@last_file,
                                  extension: File.extname(@last_file))
    find_product(table)
    return puts "#{@request} can not be found in database." if @products.empty?

    @products = MinMaxSearcher.new(@products, @current_region,
                                   REGIONS_COLOMNS_LINK).find_min_max
    find_similar_products(table)
    display_results
  end

  def input_request
    puts 'What product are you looking for?'
    loop do
      input = gets.chomp
      return input unless ['', ' '].include?(input)

      puts 'Please, write not empty request.'
      next
    end
  end

  def find_product(table)
    (FIRST_PRODUCT_ROW..table.last_row).each do |row|
      next unless table.cell(row, 'A').to_s.split(/[-,'"()\s]/)
                       .include?(@request.upcase)

      product = table.cell(row, 'A')
      price = table.cell(row, REGIONS_COLOMNS_LINK[@current_region])
      @products[product] = [price, price, File.basename(@last_file, '.*'),
                            price, File.basename(@last_file, '.*')]
    end
  end

  def find_similar_products(table)
    @products.each_key do |product|
      @similar[product] = []
      (9..table.last_row).each do |row|
        tmp = table.cell(row, 'A').to_s
        next unless compare_price(table, row, product) &&
                    product != tmp

        @similar[product] << tmp
      end
    end
  end

  def compare_price(table, row, product)
    table.cell(row, REGIONS_COLOMNS_LINK[@current_region]).to_f.round(1) ==
      @products[product][0].to_f.round(1)
  end

  def display_results
    @products.each do |product, value|
      puts "#{product} is #{value[0]} BYN in Минск these days."
      puts "Lowest was on #{value[2]} at price #{value[1]} BYN"
      puts "Maximum was on #{value[4]} at price #{value[3]} BYN"
      display_similar(product)
      puts ''
    end
  end

  def display_similar(product)
    if @similar[product].empty?
      puts 'There are no products for similar price.'
    else
      puts 'For similar price you also can afford: '
      @similar[product].each do |element|
        puts element.to_s
      end
    end
  end
end
