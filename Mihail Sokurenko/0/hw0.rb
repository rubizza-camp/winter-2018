require 'roo'
require 'roo-xls'

class Price
  def initialize
    @c = Roo::Excelx.new('./date/Average_prices(serv)-10-2018.xlsx')
    puts 'What price are u looking for?'
    @name = gets.chomp
    @pr = 0
  end

  def find
    @k = 0
    @l = 0
    @c.each_with_index do |mas, i|
      mas.each_with_index do |arr, j|
        (@l = i + 1) if check(mas)
        (@k = j) if arr == 'г. Минск'
        @pr = @c.row(@l)[@k]
      end
    end
    out
  end

  def check(mas)
    !mas[0].nil? && mas[0] == @name.upcase || mas[0] =~ /#{@name.upcase}[.,) ]{1}/
  end

  def similar
    a = []
    @c.each do |mas|
      mas.each do |arr|
        (a << mas[0]) if arr == @pr && mas[0] !~ /#{@name.upcase}[.,) ]{1}/ && mas[0] != @name.upcase
      end
    end
    similar_out(a.uniq)
  end

  def out
    if @pr.nil? && @l.zero?
      puts "No #{@name} in table"
    else
      puts "'#{@name.capitalize}' is #{@pr} BYN in Minsk on these days"
      MinMaxPrice.new(@k, @pr, @name).min_max
      similar
    end
  end

  def similar_out(arr)
    if arr.empty?
      puts 'No product with similar price'
    else
      str = arr.map { |r| r.to_s.capitalize.gsub(/\s+/, ' ') }.join(', ')
      puts "For similar price u can buy #{str}"
    end
  end
end

class MinMaxPrice
  def initialize(kol, price, name)
    @k = kol
    @pr = price
    @name = name
    @all = []
    @date = { 'январь': '01', 'февраль': '02', 'март': '03', 'апрель': '04',
              'май': '05', 'июнь': '06', 'июль': '07', 'август': '08',
              'сентябрь': '09', 'октябрь': '10', 'ноябрь': '11',
              'декабрь': '12' }
  end

  def all_files
    Dir.foreach('./date').each do |file|
      case File.extname(file)
      when '.xlsx' then
        @all << Roo::Excelx.new("./date/#{file}")
      when '.xls' then
        @all << Roo::Excel.new("./date/#{file}")
      end
    end
    @all
  end

  def minim(file, min, dat)
    coef = old_price(file)
    file.each_with_index do |_, i|
      next unless file.row(i)[0] == @name.upcase || file.row(i)[0] =~ /#{@name.upcase}[.,) ]{1}/

      min = checkmin(file.row(i)[@k], min, coef, dat)
    end
    min
  end

  def maxim(file, max, dat)
    coef = old_price(file)
    file.each_with_index do |_, i|
      next unless file.row(i)[0] == @name.upcase || file.row(i)[0] =~ /#{@name.upcase}[.,) ]{1}/

      max = checkmax(file.row(i)[@k], max, coef, dat)
    end
    max
  end

  def checkmin(file, min, coef, dat)
    if !file.nil? && (coef * file) < min
      min = coef * file
      @min_dat = dat
    end
    min
  end

  def checkmax(file, max, coef, dat)
    if !file.nil? && (coef * file) > max
      max = coef * file
      @max_dat = dat
    end
    max
  end

  def get_date(file)
    dates = file.row(3)[0].split(' ')
    @date.each do |d, t|
      (dates[1] = t) if dates[1] == d.to_s
    end
    dates[1..2]
  end

  def old_price(file)
    date = get_date(file)
    date[1].to_i < 2017 ? 0.0001 : 1
  end

  def min_out(min_v, min_dat)
    puts"Lowest price was on #{min_dat[0]}/#{min_dat[1]} at #{min_v} BYN"
  end

  def max_out(max_v, max_dat)
    puts"Highest price was on #{max_dat[0]}/#{max_dat[1]} at #{max_v} BYN"
  end

  def min_max
    min = max = @pr
    all_files
    @all.each do |f|
      next if f.nil?

      dat = get_date(f)
      min = minim(f, min, dat)
      max = maxim(f, max, dat)
    end
    min_out(min, @min_dat)
    max_out(max, @max_dat)
  end
end

s = Price.new
s.find
