require 'creek'
class PriceStatistic
  def initialize
    @creek = Creek::Book.new 'сборка.xlsx'
    @average_in_mounth = Hash.new { |mounth, min_price| }
    set_product_name
    @nowaday_price = 0
  end

  def set_product_name
    puts 'What price are you looking for?'
    @product = gets.chomp
  end

  def nowadays_product_price
    sum = 0.0
    kol = 0
    @creek.sheets.last.simple_rows.each do |row|
      if row['A'].downcase.include? "#{@product.downcase}"
        sum += row['G']
        kol += 1
      end
    end
    product_availability(kol, sum)
  end

  def product_availability(kol, sum)
    if kol.zero?
      puts "#{@product} can not be found in database."
    else
      puts "#{@product} is #{@nowaday_price = sum / kol} BYN in Minsk these day"
    end
  end

  def min_and_max_product_prices
    mounth = 1
    @creek.sheets.each do |sheet|
      sheet.simple_rows.each do |row|
        count_total_price(row, mounth)
      end
      mounth += 1
    end
    min_max_output
  end

  def count_total_price(row, mounth)
    avg_price = 0
    kol = 0
    if row['A'].downcase.include? "#{@product.downcase}"
      avg_price += row['C'].to_f + row['D'].to_f + row['E'].to_f + row['F'].to_f + row['G'].to_f + row['I'].to_f
      kol += 6
    end
    kol *= 10_000 if mounth <= 96 && !kol.zero?
    @average_in_mounth[mounth] = avg_price / kol if !kol.zero?
  end

  def min_max_output
    min = @average_in_mounth.key(@average_in_mounth.values.min)
    max = @average_in_mounth.key(@average_in_mounth.values.max)
    puts "Lowest was on #{2009 + min / 12}/#{min % 12} at price  #{@average_in_mounth.values.min}"
    puts "Maximum was on #{2009 + max / 12}/#{max % 12} at #{@average_in_mounth.values.max}"
  end

  def products_for_similar_price
    cheep_products = []
    @creek.sheets.last.simple_rows.each do |row|
      sum = row['C'].to_f + row['D'].to_f + row['E'].to_f + row['F'].to_f + row['G'].to_f + row['I'].to_f
      cheep_products << row['A'] if row['A'] != ~ /@product/i && sum < @nowaday_price * 6
    end
    puts 'For similar price you also can afford:'
    puts cheep_products
  end
end

a = PriceStatistic.new
a.nowadays_product_price
a.min_and_max_product_prices
a.products_for_similar_price
