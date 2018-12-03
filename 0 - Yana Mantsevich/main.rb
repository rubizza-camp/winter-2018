require 'creek'

class PriceStatistic
  def initialize
    @creek = Creek::Book.new 'сборка.xlsx'
    @average_in_mounth = Hash.new { |mounth, min_price| }
    @product = set_product_name
    @nowaday_price = 0
  end

  def set_product_name
    puts 'What price are you looking for?'
    product = gets.chomp
  end

  def nowadays_product_price
    sum = 0.0
    kol = 0
    @creek.sheets.last.simple_rows.each do |row|
      if row['A'] =~ /#{@product}/i
        sum += row['G']
        kol += 1
      end
    end

    if kol == 0
      puts "#{@product} can not be found in database."
    else
      puts "#{@product} is #{@nowaday_price = sum / kol} BYN in Minsk these days"
    end
  end

  def min_and_max_product_prices
    mounth = 1
    @creek.sheets.each do |sheet|
      avg_price = 0
      kol = 0
      sheet.simple_rows.each do |row|
        if row['A'] =~ /#{@product}/i
          avg_price += row['C'].to_f + row['D'].to_f + row['E'].to_f + row['F'].to_f + row['G'].to_f + row['I'].to_f
          kol += 6
        end
      end
      kol *= 10_000 if mounth <= 96
      @average_in_mounth[mounth] = avg_price / kol
      mounth += 1
    end
    puts "Lowest was on #{2009 + @average_in_mounth.key(@average_in_mounth.values.min) / 12}/#{@average_in_mounth.key(@average_in_mounth.values.min) % 12} at price  #{@average_in_mounth.values.min}"
    puts "Maximum was on #{2009 + @average_in_mounth.key(@average_in_mounth.values.max) / 12}/#{@average_in_mounth.key(@average_in_mounth.values.max) % 12} at #{@average_in_mounth.values.max}"
  end

  def products_for_similar_price
    cheep_products = []
    kol = 0
    sum = 0

    @creek.sheets.last.simple_rows.each do |row|
      if row['A'] != ~ /@product/i && row['C'].to_f + row['D'].to_f + row['E'].to_f + row['F'].to_f + row['G'].to_f + row['I'].to_f < @nowaday_price * 6
        cheep_products << row['A']
      end
    end
    puts 'For similar price you also can afford:'
    puts cheep_products
  end
end

a = PriceStatistic.new
a.nowadays_product_price
a.min_and_max_product_prices
a.products_for_similar_price
