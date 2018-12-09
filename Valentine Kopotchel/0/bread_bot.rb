begin
  require 'roo'
  require 'roo-xls'
rescue LoadError
  puts "Use 'bundle install --system' to download missing gems"
  exit
end
# some monkey patching
class Regexp
  def self.and_union(*res)
    new res.flatten.map(&:source).join
  end
end
HASH_OF_TABLES = {
  '2009-01' => 'data/prices_tov_0109.xls',
  '2009-02' => 'data/prices_tov_0209.xls',
  '2009-03' => 'data/prices_tov_0309.xls',
  '2009-04' => 'data/prices_tov_0409.xls',
  '2009-05' => 'data/prices_tov_0509.xls',
  '2009-06' => 'data/prices_tov_0609.xls',
  '2009-07' => 'data/prices_tov_0709.xls',
  '2009-08' => 'data/prices_tov_0809.xls',
  '2009-09' => 'data/prices_tov_0909.xls',
  '2009-10' => 'data/prices_tov_1009.xls',
  '2009-11' => 'data/prices_tov_1109.xls',
  '2009-12' => 'data/prices_tov_1209.xls',
  '2010-01' => 'data/prices_tov_0110.xls',
  '2010-02' => 'data/prices_tov_0210.xls',
  '2010-03' => 'data/prices_tov_0310.xls',
  '2010-04' => 'data/prices_tov_0410.xls',
  '2010-05' => 'data/prices_tov_0510.xls',
  '2010-06' => 'data/prices_tov_0610.xls',
  '2010-07' => 'data/prices_tov_0710.xls',
  '2010-08' => 'data/prices_tov_0810.xls',
  '2010-09' => 'data/prices_tov_0910.xls',
  '2010-10' => 'data/prices_tov_1010.xls',
  '2010-11' => 'data/prices_tov_1110.xls',
  '2010-12' => 'data/prices_tov_1210.xls',
  '2011-01' => 'data/prices_tov_0111.xls',
  '2011-02' => 'data/prices_tov_0211.xls',
  '2011-03' => 'data/prices_tov_0311.xls',
  '2011-04' => 'data/prices_tov_0411.xls',
  '2011-05' => 'data/prices_tov_0511.xls',
  '2011-06' => 'data/prices_tov_0611.xls',
  '2011-07' => 'data/prices_tov_0711.xls',
  '2011-08' => 'data/prices_tov_0811.xls',
  '2011-09' => 'data/prices_tov_0911.xls',
  '2011-10' => 'data/prices_tov_1011.xls',
  '2011-11' => 'data/prices_tov_1111.xls',
  '2011-12' => 'data/prices_tov_1211.xls',
  '2012-01' => 'data/prices_tov_0112.xls',
  '2012-02' => 'data/prices_tov_0212.xls',
  '2012-03' => 'data/prices_tov_0312.xls',
  '2012-04' => 'data/prices_tov_0412.xls',
  '2012-05' => 'data/prices_tov_0512.xls',
  '2012-06' => 'data/prices_tov_0612.xls',
  '2012-07' => 'data/prices_tov_0712.xls',
  '2012-08' => 'data/prices_tov_0812.xls',
  '2012-09' => 'data/prices_tov_0912.xls',
  '2012-10' => 'data/prices_tov_1012.xls',
  '2012-11' => 'data/prices_tov_1112.xls',
  '2012-12' => 'data/prices_tov_1212.xls',
  '2013-01' => 'data/prices_tov_0113.xls',
  '2013-02' => 'data/prices_tov_0213.xls',
  '2013-03' => 'data/prices_tov_0313.xls',
  '2013-04' => 'data/prices_tov_0413.xls',
  '2013-05' => 'data/prices_tov_0513.xls',
  '2013-06' => 'data/prices_tov_0613.xls',
  '2013-07' => 'data/prices_tov_0713.xls',
  '2013-08' => 'data/prices_tov_0813.xls',
  '2013-09' => 'data/average_prices_goods_0913.xls',
  '2013-10' => 'data/prices_1013.xls',
  '2013-11' => 'data/prices_1113new.xls',
  '2013-12' => 'data/prices_tov_1213.xls',
  '2014-01' => 'data/prices_tov_0114.xls',
  '2014-02' => 'data/prices_tov_0214_(1).xls',
  '2014-03' => 'data/prices_tov_0314.xls',
  '2014-04' => 'data/prices_tov_0414.xls',
  '2014-05' => 'data/prices_tov_0514.xls',
  '2014-06' => 'data/prices_tov_0614.xls',
  '2014-07' => 'data/prices_tov_0714.xls',
  '2014-08' => 'data/prices_tov_0814.xls',
  '2014-09' => 'data/prices_tov_0914.xls',
  '2014-10' => 'data/prices_tov_1014.xls',
  '2014-11' => 'data/prices_tov_1114.xls',
  '2014-12' => 'data/prises_cpi_12.xls',
  '2015-01' => 'data/prices_tov_01_2015.xls',
  '2015-02' => 'data/prices_tov_02_2015.xls',
  '2015-03' => 'data/srednie_ceny_tovary_03_2015.xls',
  '2015-04' => 'data/prices_tov_04_2015.xls',
  '2015-05' => 'data/prices_tov05_2015.xls',
  '2015-06' => 'data/ceny_06_2015_internet.xls',
  '2015-07' => 'data/prices_tov_07_2015.xls',
  '2015-08' => 'data/prices_tov_08_2015.xls',
  '2015-09' => 'data/ceny_09_2015_internet.xlsx',
  '2015-10' => 'data/prices_10_2015_goods.xlsx',
  '2015-11' => 'data/Average prices_tov_11_2015_17_02.xlsx',
  '2015-12' => 'data/prices_goods_2-2015_16_02.xlsx',
  '2016-01' => 'data/prices_tov-01-2016.xlsx',
  '2016-02' => 'data/Average pr_tov-02-2016.xlsx',
  '2016-03' => 'data/Average prices_goods_03_2016.xlsx',
  '2016-04' => 'data/prices_tov-04-2016.xlsx',
  '2016-05' => 'data/цены-05-201610_06_2016.xlsx',
  '2016-06' => 'data/price-06-2016.xlsx',
  '2016-07' => 'data/price-07-2016.xlsx',
  '2016-08' => 'data/Average prices _goods-08-2016.xlsx',
  '2016-09' => 'data/Average_prices_goods-09-2016.xlsx',
  '2016-10' => 'data/Prices_goods_10_2016.xlsx',
  '2016-11' => 'data/Average prices_tov_11_2016.xlsx',
  '2016-12' => 'data/prices_tov-12-2016.xlsx',
  '2017-01' => 'data/price-01-2017.xlsx',
  '2017-02' => 'data/Average_prices_02-2017.xlsx',
  '2017-03' => 'data/Average_prices(serv)-03-2017.xlsx',
  '2017-04' => 'data/Average_prices(serv)-04-2017.xlsx',
  '2017-05' => 'data/Average prices(serv)-05-2017.xlsx',
  '2017-06' => 'data/Average_prices(serv)-06-2017.xls',
  '2017-07' => 'data/Average_prices(serv)-07-2017-2.xlsx',
  '2017-08' => 'data/Average_prices(serv)-08-2017.xlsx',
  '2017-09' => 'data/Average_prices(serv)-09-2017.xls',
  '2017-10' => 'data/Average_prices(serv)-10-2017.xlsx',
  '2017-11' => 'data/Average prices(serv)-07-2018.xlsx',
  '2017-12' => 'data/Average prices(serv)-12-2017.xlsx',
  '2018-01' => 'data/Average_prices(serv)-01-2018.xlsx',
  '2018-02' => 'data/Average_prices(serv)-02-2018.xlsx',
  '2018-03' => 'data/Average_prices(serv)-03-2018.xlsx',
  '2018-04' => 'data/Average_prices(serv)-04-2018.xlsx',
  '2018-05' => 'data/Average prices(serv)-05-2018.xlsx',
  '2018-06' => 'data/Average_prices(serv)-06-2018.xlsx',
  '2018-07' => 'data/Average prices(serv)-07-2018.xlsx',
  '2018-08' => 'data/Average_prices(serv)-08-2018.xlsx',
  '2018-09' => 'data/Average_prices(serv)-09-2018.xlsx',
  '2018-10' => 'data/Average_prices(serv)-10-2018.xlsx'
}.freeze
# Doing some dirty work to make less code in BreadBot
class BotHelper
  PRICE_COLUMN_MINSK = 16
  NAME_COLUMN = 0

  def build_page(key)
    path = HASH_OF_TABLES[key]
    xlsx = Roo::Spreadsheet.open(path)
    xlsx.sheet 0
  end

  def deflation?(date)
    date[0, 4] < '2017'
  end

  def exists?(arg)
    arg.to_s.length.positive?
  end

  def num?(arg)
    arg.is_a? Numeric
  end

  def build_hash(key)
    fin_hash = {}
    condition = deflation? key
    build_page(key).each do |row|
      next unless exists?(row[NAME_COLUMN]) && num?(row[PRICE_COLUMN_MINSK])

      val = row[PRICE_COLUMN_MINSK]
      val /= 10_000.0 if condition
      fin_hash[row[NAME_COLUMN]] = val
    end
    fin_hash
  end

  def make_normal(str)
    str.swapcase.capitalize
  end

  def reg_build(str)
    str = str.strip
    r = str.upcase
    temp = Regexp.new("(#{r}$|#{r}\s|#{r},)")
    Regexp.and_union(/(^|[\P{L}])/, temp)
  end

  def split_key(str)
    [str[0, 4], str[-2, 2]]
  end

  def minmax_assign(hash)
    min = hash.keys.min
    max = hash.keys.max
    a = hash[min]
    b = hash[max]
    [min, max, a, b]
  end

  def write_minmax_info(hash)
    min, max, a, b = minmax_assign(hash)
    puts "Lowest was on #{(split_key a)[1]}/#{(split_key a)[0]} "\
"at #{min.round(2)} BYN"
    puts "Highest was on #{(split_key b)[1]}/#{(split_key b)[0]} "\
"at #{max.round(2)} BYN"
  end
end
# The main class
class BreadBot
  def initialize
    @big_hash = {}
    dog = BotHelper.new
    HASH_OF_TABLES.each_key do |key|
      @big_hash[key] = dog.build_hash key
    end
    @h = @big_hash[@big_hash.keys.max]
  end

  def gen_string(key)
    ' is ' + @h[key].round(2).to_s + 'BYN in Minsk nowadays'
  end

  def count(key, str)
    h = {}
    @big_hash.each_key do |date|
      val = get_price_by_date(date, key, str)
      h[date] = val if val > -1
    end
    min = h.values.min
    max = h.values.max
    { min => h.key(min), max => h.key(max) }
  end

  def get_price_by_date(date, key, str)
    work_hash = hash[date]
    return work_hash[key] if work_hash.key? key

    a = find_match(BotHelper.new.reg_build(str), work_hash)
    return work_hash[a[0]] if a.size == 1

    -1
  end

  def hash
    @big_hash
  end

  def find_match(reg, hash = @h)
    a = []
    hash.each_key do |key|
      a << key if key.match? reg
    end
    a
  end

  def prepare_ind(inv_hash, key)
    temp_arr = inv_hash.to_a.sort
    x, _y = temp_arr.transpose
    [x.index(@h[key]), x]
  end

  def get_indexes(inv_hash, key)
    ind, x = prepare_ind(inv_hash, key)
    indexes = if ind.zero?
                [1, 2]
              elsif ind == x.size - 1
                [ind - 1, ind - 2]
              else
                [ind - 1, ind + 1]
              end
    [indexes, x]
  end

  def level_2_string_generator(inv_hash, arr_of_num, keys)
    dog = BotHelper.new
    puts 'For similar price you also can afford '\
    "#{dog.make_normal inv_hash[arr_of_num[keys[0]]]}"\
              " and #{dog.make_normal inv_hash[arr_of_num[keys[1]]]}"
  end

  def level_2_and_3(key, str)
    puts "#{str} #{gen_string(key)}"
    inv_hash = @h.invert
    keys, x = get_indexes(inv_hash, key)
    level_2_string_generator(inv_hash, x, keys)
    level_3(key, str)
  end

  def level_3(key, str)
    min_info = count(key, str)
    BotHelper.new.write_minmax_info(min_info)
  end

  def some_preparations
    puts 'What price are you looking for?'
    str = gets.strip
    r = BotHelper.new.reg_build(str)
    [find_match(r), str]
  end

  def many_keys(arr)
    puts "I can't understand what do you mean:( So here are some prices you"\
'might be interested in:'
    arr.each do |key|
      puts BotHelper.new.make_normal(key) + ' ' + gen_string(key)
    end
  end

  def loop_body(arr, str)
    if arr.size.zero?
      puts str + ' can not be found in database'
    elsif arr.size == 1
      level_2_and_3(arr[0], str)
    else
      many_keys(arr)
    end
  end

  def run
    loop do
      a, str = some_preparations
      loop_body(a, str)
    end
  end
end
puts 'Loading data...'
b = BreadBot.new
b.run
