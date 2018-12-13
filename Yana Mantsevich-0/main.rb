require 'creek'
class PriceStatistic
  YEARS = %w[09 10 11 12 13 14 15 16 17 18].freeze
  MONTHS = %w[01 02 03 04 05 06 07 08 09 10 11 12].freeze
  ROWS = %w[G I K M Q S].freeze
  MINSK_REGION = 'Q'.freeze
  PRODUCT = 'A'.freeze
  def initialize
    @nowaday_price = 0
    @prices = {}
  end

  def show_task_results
    set_product_name
    nowadays_product_price
    min_and_max_product_prices
    products_for_similar_price
  end

  private

  def set_product_name
    puts 'What price are you looking for?'
    @product = gets.chomp
  end

  def nowadays_product_price
    sum = 0.0
    amount = 0
    last_month.simple_rows.select do |row|
      if row[PRODUCT].to_s.match?(/#{@product}/i)
        sum += row[MINSK_REGION].to_f
        amount += 1
      end
    end
    product_available(amount, sum)
  end

  def product_available(amount, sum)
    if amount.zero?
      puts "#{@product} can not be found in database."
    else
      puts "#{@product} is #{@nowaday_price = sum / amount} BYN in Minsk these day"
    end
  end

  def count_total_price(row, year, month)
    avg_price = 0
    amount = 0
    if row[PRODUCT].to_s.match?(/#{@product}/i)
      avg_price += count_sum(row)
      amount += 6
    end
    check_denominanion(amount, avg_price, year, month)
  end

  def check_denominanion(amount, avg_price, year, month)
    amount *= 10_000 if year.to_i < 17 && !amount.zero?
    @prices[month + '/20' + year] = avg_price / amount unless amount.zero?
  end

  def min_and_max_product_prices
    YEARS.each do |year|
      MONTHS.each do |month|
        break if year.to_i == 18 && month.to_i == 12

        creek = Creek::Book.new "#{month}-20#{year}.xlsx"
        creek.sheets[0].simple_rows.each do |row|
          count_total_price(row, year, month)
        end
      end
    end
    min_max_output
  end

  def min_max_output
    puts "Lowest was on #{min_max_values[0]} at price #{@prices.values.min}"
    puts "Maximum was on #{min_max_values[1]} at #{@prices.values.max}"
  end

  def min_max_values
    [@prices.key(@prices.values.min), @prices.key(@prices.values.max)]
  end

  def similar_price_array
    last_month.simple_rows.select do |row|
      puts row[PRODUCT] if row[PRODUCT] != ~ /#{@product}/i && check_prices(row)
    end
  end

  def check_prices(row)
    count_sum(row) < @nowaday_price * 7.5 && count_sum(row) > @nowaday_price * 4.5
  end

  def products_for_similar_price
    puts 'For similar price you also can afford:'
    puts similar_price_array
  end

  def last_month
    creek = Creek::Book.new '11-2018.xlsx'
    creek.sheets[0]
  end

  def count_sum(row)
    ROWS.map { |i| row[i].to_f }.inject(:+)
  end
end

a = PriceStatistic.new
a.show_task_results
