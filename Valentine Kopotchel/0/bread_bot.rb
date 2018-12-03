begin
require "roo"
require 'roo-xls'
rescue LoadError
  puts "Use 'bundle install --system' to download missing gems"
  exit
  end
class BreadBot
  HASH_OF_TABLES={
      "22016"=>'data/Average pr_tov-02-2016.xlsx',
      '52017'=>'data/Average prices(serv)-05-2017.xlsx',
      '72018'=>'data/Average prices(serv)-07-2018.xlsx',
      '112017'=>'data/Average prices(serv)-07-2018.xlsx',
      '52018'=>'data/Average prices(serv)-05-2018.xlsx',
      '122017'=>'data/Average prices(serv)-12-2017.xlsx',
      '82016'=>'data/Average prices _goods-08-2016.xlsx',
      '32016'=>'data/Average prices_goods_03_2016.xlsx',
      '112015'=>'data/Average prices_tov_11_2015_17_02.xlsx',
      '112016'=>'data/Average prices_tov_11_2016.xlsx',
      '12018'=>'data/Average_prices(serv)-01-2018.xlsx',
      '22018'=>'data/Average_prices(serv)-02-2018.xlsx',
      '32017'=>'data/Average_prices(serv)-03-2017.xlsx',
      '32018'=>'data/Average_prices(serv)-03-2018.xlsx',
      '42017'=>'data/Average_prices(serv)-04-2017.xlsx',
      '42018'=>'data/Average_prices(serv)-04-2018.xlsx',
      '62017'=>'data/Average_prices(serv)-06-2017.xls',
      '62018'=>'data/Average_prices(serv)-06-2018.xlsx',
      '72017'=>'data/Average_prices(serv)-07-2017-2.xlsx',
      '82017'=>'data/Average_prices(serv)-08-2017.xlsx',
      '82018'=>'data/Average_prices(serv)-08-2018.xlsx',
      '92017'=>'data/Average_prices(serv)-09-2017.xls',
      '92018'=>'data/Average_prices(serv)-09-2018.xlsx',
      '102017'=>'data/Average_prices(serv)-10-2017.xlsx',
      '102018'=>'data/Average_prices(serv)-10-2018.xlsx',
      '22017'=>'data/Average_prices_02-2017.xlsx',
      '92016'=>'data/Average_prices_goods-09-2016.xlsx',
      '92013'=>'data/average_prices_goods_0913.xls',
      '62015'=>'data/ceny_06_2015_internet.xls',
      '92015'=>'data/ceny_09_2015_internet.xlsx',
      '12017'=>'data/price-01-2017.xlsx',
      '62016'=>'data/price-06-2016.xlsx',
      '72016'=>'data/price-07-2016.xlsx',
      '102015'=>'data/prices_10_2015_goods.xlsx',
      '102013'=>'data/prices_1013.xls',
      '112013'=>'data/prices_1113new.xls',
      '122015'=>'data/prices_goods_2-2015_16_02.xlsx',
      '102016'=>'data/Prices_goods_10_2016.xlsx',
      '52015'=>'data/prices_tov05_2015.xls',
      '12016'=>'data/prices_tov-01-2016.xlsx',
      '42016'=>'data/prices_tov-04-2016.xlsx',
      '122016'=>'data/prices_tov-12-2016.xlsx',
      '12015'=>'data/prices_tov_01_2015.xls',
      '22015'=>'data/prices_tov_02_2015.xls',
      '42015'=>'data/prices_tov_04_2015.xls',
      '72015'=>'data/prices_tov_07_2015.xls',
      '82015'=>'data/prices_tov_08_2015.xls',
      '12009'=>'data/prices_tov_0109.xls',
      '12010'=>'data/prices_tov_0110.xls',
      '12011'=>'data/prices_tov_0111.xls',
      '12012'=>'data/prices_tov_0112.xls',
      '12013'=>'data/prices_tov_0113.xls',
      '12014'=>'data/prices_tov_0114.xls',
      '22009'=>'data/prices_tov_0209.xls',
      '22010'=>'data/prices_tov_0210.xls',
      '22011'=>'data/prices_tov_0211.xls',
      '22012'=>'data/prices_tov_0212.xls',
      '22013'=>'data/prices_tov_0213.xls',
      '22014'=>'data/prices_tov_0214_(1).xls',
      '32009'=>'data/prices_tov_0309.xls',
      '32010'=>'data/prices_tov_0310.xls',
  '32011'=>'data/prices_tov_0311.xls',
      '32012'=>'data/prices_tov_0312.xls',
  '32013'=>'data/prices_tov_0313.xls',
      '32014'=>'data/prices_tov_0314.xls',
  '42009'=>'data/prices_tov_0409.xls',
      '42010'=>'data/prices_tov_0410.xls',
  '42011'=>'data/prices_tov_0411.xls',
      '42012'=>'data/prices_tov_0412.xls',
  '42013'=>'data/prices_tov_0413.xls',
      '42014'=>'data/prices_tov_0414.xls',
  '52009'=>'data/prices_tov_0509.xls',
      '52010'=>'data/prices_tov_0510.xls',
  '52011'=>'data/prices_tov_0511.xls',
      '52012'=>'data/prices_tov_0512.xls',
  '52013'=>'data/prices_tov_0513.xls',
      '52014'=>'data/prices_tov_0514.xls',
  '62009'=>'data/prices_tov_0609.xls',
      '62010'=>'data/prices_tov_0610.xls',
  '62011'=>'data/prices_tov_0611.xls',
      '62013'=>'data/prices_tov_0613.xls',
  '62012'=>'data/prices_tov_0612.xls',
      '62014'=>'data/prices_tov_0614.xls',
  '72009'=>'data/prices_tov_0709.xls',
      '72010'=>'data/prices_tov_0710.xls',
  '72011'=>'data/prices_tov_0711.xls',
      '72012'=>'data/prices_tov_0712.xls',
  '72013'=>'data/prices_tov_0713.xls',
      '72014'=>'data/prices_tov_0714.xls',
  '82009'=>'data/prices_tov_0809.xls',
      '82010'=>'data/prices_tov_0810.xls',
  '82011'=>'data/prices_tov_0811.xls',
      '82012'=>'data/prices_tov_0812.xls',
  '82013'=>'data/prices_tov_0813.xls',
      '82014'=>'data/prices_tov_0814.xls',
  '92009'=>'data/prices_tov_0909.xls',
      '92010'=>'data/prices_tov_0910.xls',
  '92011'=>'data/prices_tov_0911.xls',
      '92012'=>'data/prices_tov_0912.xls',
  '102009'=>'data/prices_tov_1009.xls',
      '92014'=>'data/prices_tov_0914.xls',
  '102010'=>'data/prices_tov_1010.xls',
      '102011'=>'data/prices_tov_1011.xls',
  '102012'=>'data/prices_tov_1012.xls',
      '102014'=>'data/prices_tov_1014.xls',
  '52016'=>'data/цены-05-201610_06_2016.xlsx',
    '32015'  =>'data/srednie_ceny_tovary_03_2015.xls',
  '122014'=>'data/prises_cpi_12.xls',
      '122013'=>'data/prices_tov_1213.xls',
  '122012'=>'data/prices_tov_1212.xls',
      '122011'=>'data/prices_tov_1211.xls',
  '122010'=>'data/prices_tov_1210.xls',
      '122009'=>'data/prices_tov_1209.xls',
  '112014'=>'data/prices_tov_1114.xls',
      '112011'=>'data/prices_tov_1111.xls',
  '112012'=>'data/prices_tov_1112.xls',
      '112010'=>'data/prices_tov_1110.xls',
  '112009'=>'data/prices_tov_1109.xls'
  }
  PRICE_COLUMN_MINSK=16
  NAME_COLUMN=0
  CURRENT_YEAR=2018
  CURRENT_MONTH=10
  BEGIN_YEAR=2009

  def initialize(month=CURRENT_MONTH, year=CURRENT_YEAR)
    path='./'+HASH_OF_TABLES[month.to_s+year.to_s]
    xlsx = Roo::Spreadsheet.open(path)
    page=xlsx.sheet 0
    @h=Hash.new
    page.each  do |row|
      if row[NAME_COLUMN].to_s.length>0&&row[PRICE_COLUMN_MINSK].is_a?(Numeric)
        @h[row[NAME_COLUMN]]=row[PRICE_COLUMN_MINSK]
      end
    end
  end

  def count(key, str)
    max=min=@h[key]
    max_month=min_month=CURRENT_MONTH
    max_year=min_year=CURRENT_YEAR
    for cur_y in BEGIN_YEAR...CURRENT_YEAR
      for cur_m in 1..12
        val=get_price_by_date(key, cur_m, cur_y, str)
        firstval=val
        if cur_y.to_i<2017
          val=val.to_f/10000.0
          end
        if (val<min&&firstval>-1)
          min=val
          min_year=cur_y
          min_month=cur_m
        end
          if (val>max)
            max=val
            max_year=cur_y
            max_month=cur_m
          end
      end
      end
      for cur_m in 1..CURRENT_MONTH
        val=get_price_by_date(key, cur_m, CURRENT_YEAR, str)
        if val<min&&val>-1
          min=val
          min_year=CURRENT_YEAR
          min_month=cur_m
        end
        if (val>max)
          max=val
          max_year=cur_y
          max_month=cur_m
        end
      end
    h= {'minmonth'=>min_month, 'minyear'=>min_year, 'min'=>min, 'maxmonth'=>max_month, 'maxyear'=>max_year, 'max'=>max}
    end

  def get_price_by_date(key, month, year, str)
    b=BreadBot.new(month, year)
    if(b.get_hash.has_key? key)
      return b.get_hash[key]
    elsif b.find_match(reg_build(str), b.get_hash).size==1
      return b.get_hash[b.find_match(reg_build(str), b.get_hash)[0]]
      else
      return -1
    end
    end

  def gen_string(key)
    ' is '+ @h[key].round(2).to_s+ 'BYN in Minsk nowadays'
  end

  def get_hash
    @h
  end

  def find_match(r, hash=@h)
    a=[]
    hash.each_key do |key|
      if(key.match(r))
        a<<key
      end
    end
    a
  end

  def reg_build(str)
    str.rstrip!
    str.lstrip!
    r=Regexp.new(str.upcase);
    r= Regexp.new( "#{r.source}$|#{r.source}\s" )
    r
  end

  def run
    while true
      puts "What price are you looking for?"
      str=gets
      str.rstrip!
      str.lstrip!
      r=reg_build(str)
      a=find_match(r)
      if a.size==0
        puts str+' can not be found in database'
      elsif a.size==1
        puts str+gen_string(a[0])
        inv_hash=@h.invert
        temp_arr=inv_hash.to_a.sort
        x,y=temp_arr.transpose
        ind= x.index(@h[a[0]])
        #For similar price you also can afford 'Йогурт' and 'Кефир'.
        if(ind==0)
          indexes=[1,2]
        else
          indexes=[ind-1, ind+1]
        end
        puts "For similar price you also can afford #{inv_hash[x[indexes[0]]].swapcase.capitalize} and #{inv_hash[x[indexes[1]]].swapcase.capitalize}"
        puts "Wait a little for price-change dynamics..."
        min_info= count(a[0], str)
        puts "Lowest was on #{min_info["minmonth"]}/#{min_info["minyear"]} at #{min_info["min"].round(2)} BYN"
        puts "Highest was on #{min_info["maxmonth"]}/#{min_info["maxyear"]} at #{min_info["max"].round(2)} BYN"

      else
        puts "I can't understand what do you mean:( So here are some prices you might be interested in:"
        a.each do |key|
          puts key.swapcase.capitalize+" "+gen_string(key)
        end

      end
    end
  end

end
#b=BreadBot.new(6, 2017)
b=BreadBot.new
b.run