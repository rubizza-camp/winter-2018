require 'roo'
require 'roo-xls'

class Price
  def initialize
    @c = Roo::Excelx.new('./date/Average_prices(serv)-10-2018.xlsx')
    puts 'What price are u looking for?'
    @name = gets.chomp
    @pr = 0
    @all = []
    @date = { 'январь': '01', 'февраль': '02', 'март': '03', 'апрель': '04',
              'май': '05', 'июнь': '06', 'июль': '07', 'август': '08',
              'сентябрь': '09', 'октябрь': '10', 'ноябрь': '11',
              'декабрь': '12' }
  end

  def find
    @k = 0
    @l = 0
    @c.each_with_index do |mas, i|
      mas.each_with_index do |arr, j|
        (@l = i + 1) if !mas[0].nil? && mas[0] == @name.upcase || mas[0] =~ /#{@name.upcase}[.,) ]{1}/
        (@k = j) if arr == 'г. Минск'
        @pr = @c.row(@l)[@k]
      end
    end
    out
  end

  def min
    min = @pr
    all_files
    @all.each do |f|
      unless f.nil?
        dat = get_date(f)
        old_price(f) ? coef = 0.0001 : coef = 1
        f.each_with_index do |_, i|
          if f.row(i)[0] == @name.upcase || f.row(i)[0] =~ /#{@name.upcase}[.,) ]{1}/
            if !f.row(i)[@k].nil? && (coef * f.row(i)[@k]) < min
              min = coef * f.row(i)[@k]
              @min_dat = dat
            end
          end
        end
      end
    end
    min_out(min, @min_dat)
  end

  def max
    max = @pr
    all_files
    @all.each do |f|
      unless f.nil?
        dat = get_date(f)
        old_price(f) ? coef = 0.0001 : coef = 1
        f.each_with_index do |_, i|
          if f.row(i)[0] == @name.upcase || f.row(i)[0] =~ /#{@name.upcase}[.,) ]{1}/
            if !f.row(i)[@k].nil? && (coef * f.row(i)[@k]) > max
              max = coef * f.row(i)[@k]
              @max_dat = dat
            end
          end
        end
      end
    end
    max_out(max, @max_dat)
  end

  def similar
    a = []
    @c.each do |mas|
      mas.each do |arr|
        (a << mas[0]) if arr == @pr && mas[0] !~ /#{@name.upcase}[.,) ]{1}/ && mas[0] != @name.upcase && !arr.nil?
      end
    end
    a = a.uniq
    similar_out(a)
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
    true if date[1].to_i < 2017
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

  def out
    if @pr.nil? && @l.zero?
      puts "No #{@name} in table"
    else
      puts "'#{@name.capitalize}' is #{@pr} BYN in Minsk in these days"
      min
      max
      similar
    end
  end

  def min_out(min_v, min_dat)
    puts"Lowest price was on #{min_dat[0]}/#{min_dat[1]} at #{min_v} BYN"
  end

  def max_out(max_v, max_dat)
    puts"Highest price was on #{max_dat[0]}/#{max_dat[1]} at #{max_v} BYN"
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

s = Price.new
s.find
