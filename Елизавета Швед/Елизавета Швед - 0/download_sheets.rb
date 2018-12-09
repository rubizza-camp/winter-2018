require 'rubygems'
require 'faraday'

class DownloadSheets
  def perform_data
    puts 'Download files:'
    links = (2009..2018).map { |number| send("generate_links_#{number}") }
    10.times do |elem|
      puts "Perform #{elem}"
      links[elem].each do |date, link|
        type = link.index('xlsx') == nil ? 'xls' : 'xlsx'
        download_file(date, link, type)
      end
    end
  end

  private
  
  def download_file(date, link, type)
    response = Faraday.get(link)
    begin
      file = File.open("./data/#{date}.#{type}", "w")
      file.write(response.body)
    rescue IOError => e
      puts e
      ensure
      file.close unless file.nil?
    end
  end
  
  def generate_links_2009
    beg_s = 'http://www.belstat.gov.by/uploads/file/prices/average_prices/2009/prices_tov_'
    end_s = '09.xls'
    data_links = {}
    (1..12).each do |e|
      month_number = e < 10 ? '0' + e.to_s : e
      data_links["#{month_number}_2009"] = "#{beg_s}#{month_number}#{end_s}"
    end
    data_links
  end
  
  def generate_links_2010
    beg_s = 'http://www.belstat.gov.by/uploads/file/prices/average_prices/2010/prices_tov_'
    end_s = '10.xls'
    data_links = {}
    (1..12).each do |e|
      month_number = e < 10 ? '0' + e.to_s : e
      data_links["#{month_number}_2010"] = "#{beg_s}#{month_number}#{end_s}"
    end
    data_links
  end
  
  def generate_links_2011
    beg_s = 'http://www.belstat.gov.by/uploads/file/prices/average_prices/2011/prices_tov_'
    end_s = '11.xls'
    data_links = {}
    (1..12).each do |e|
      month_number = e < 10 ? '0' + e.to_s : e
      data_links["#{month_number}_2011"] = "#{beg_s}#{month_number}#{end_s}"
    end
    data_links
  end
  
  def generate_links_2012
    beg_s = 'http://www.belstat.gov.by/uploads/file/prices/average_prices/2012/prices_tov_'
    end_s = '12.xls'
    data_links = {}
    (1..12).each do |e|
      month_number = e < 10 ? '0' + e.to_s : e
      data_links["#{month_number}_2012"] = "#{beg_s}#{month_number}#{end_s}"
    end
    data_links
  end
  
  def generate_links_2013
    beg_s = 'http://www.belstat.gov.by/uploads/file/prices/average_prices/2013/prices_tov_'
    end_s = '13.xls'
    data_links = {}
    (1..10).each do |e|
      month_number = e < 10 ? '0' + e.to_s : e
      data_links["#{month_number}_2013"] = "#{beg_s}#{month_number}#{end_s}"
    end
    data_links['11_2013'] = 'http://www.belstat.gov.by/uploads/file/prices/average_prices/2013/prices_1113new.xls'
    data_links['12_2013'] = 'http://www.belstat.gov.by/uploads/file/prices/average_prices/2013/prices_tov_1213.xls'
    data_links
  end
  
  def generate_links_2014
    beg_s = 'http://www.belstat.gov.by/kscms/uploads/file/prices/average_prices/2014/prices_tov_'
    end_s = '14.xls'
    data_links = {}
    (1..11).each do |e|
      month_number = e < 10 ? '0' + e.to_s : e
      data_links["#{month_number}_2014"] = "#{beg_s}#{month_number}#{end_s}"
    end
    data_links['12_2014'] = 'http://www.belstat.gov.by/kscms/uploads/file/prices/average_prices/prises_cpi_12.xls'
    data_links
  end
  
  def generate_links_2015
    data_links = {}
    data_links['01_2015'] = 'http://www.belstat.gov.by/kscms/uploads/file/prices/average_prices/2015/prices_tov_01_2015.xls'
    data_links['02_2015'] = 'http://www.belstat.gov.by/kscms/uploads/file/prices/average_prices/2015/prices_tov_02_2015.xls'
    data_links['03_2015'] = 'http://www.belstat.gov.by/kscms/uploads/file/U_rasprostr/srednie_ceny_tovary_03_2015.xls'
    data_links['04_2015'] = 'http://www.belstat.gov.by/kscms/uploads/file/U_rasprostr/prices_tov_04_2015.xls'
    data_links['05_2015'] = 'http://www.belstat.gov.by/kscms/uploads/file/U_rasprostr/prices_tov05_2015.xls'
    data_links['06_2015'] = 'http://www.belstat.gov.by/kscms/uploads/file/prices/ceny_06_2015_internet.xls'
    data_links['07_2015'] = 'http://www.belstat.gov.by/kscms/uploads/file/U_rasprostr/prices_tov_07_2015.xls'
    data_links['08_2015'] = 'http://www.belstat.gov.by/kscms/uploads/file/U_rasprostr/prices_tov_08_2015.xls'
    data_links['09_2015'] = 'http://www.belstat.gov.by/kscms/uploads/file/prices/ceny_09_2015_internet.xlsx'
    data_links['10_2015'] = 'http://www.belstat.gov.by/kscms/uploads/file/prices/prices_10_2015_goods.xlsx'
    data_links['11_2015'] = 'http://www.belstat.gov.by/upload-belstat/upload-belstat-excel/Oficial_statistika/Average%20prices_tov_11_2015_17_02.xlsx'
    data_links['12_2015'] = 'http://www.belstat.gov.by/upload-belstat/upload-belstat-excel/Oficial_statistika/prices_goods_2-2015_16_02.xlsx'
    data_links
  end
  
  def generate_links_2016
    data_links = {}
    data_links['01_2016'] = 'http://www.belstat.gov.by/upload-belstat/upload-belstat-excel/Oficial_statistika/prices_tov-01-2016.xlsx'
    data_links['02_2016'] = 'http://www.belstat.gov.by/upload-belstat/upload-belstat-excel/Oficial_statistika/Average%20pr_tov-02-2016.xlsx'
    data_links['03_2016'] = 'http://www.belstat.gov.by/upload-belstat/upload-belstat-excel/Oficial_statistika/Average%20prices_goods_03_2016.xlsx'
    data_links['04_2016'] = 'http://www.belstat.gov.by/upload-belstat/upload-belstat-excel/Oficial_statistika/prices_tov-04-2016.xlsx'
    data_links['05_2016'] = 'http://www.belstat.gov.by/upload-belstat/upload-belstat-excel/%D1%86%D0%B5%D0%BD%D1%8B-05-201610_06_2016.xlsx'
    data_links['06_2016'] = 'http://www.belstat.gov.by/upload-belstat/upload-belstat-excel/Oficial_statistika/price-06-2016.xlsx'
    data_links['07_2016'] = 'http://www.belstat.gov.by/upload-belstat/upload-belstat-excel/Oficial_statistika/price-07-2016.xlsx'
    data_links['08_2016'] = 'http://www.belstat.gov.by/upload-belstat/upload-belstat-excel/Oficial_statistika/Average%20prices%20_goods-08-2016.xlsx'
    data_links['09_2016'] = 'http://www.belstat.gov.by/upload-belstat/upload-belstat-excel/Oficial_statistika/Average_prices_goods-09-2016.xlsx'
    data_links['10_2016'] = 'http://www.belstat.gov.by/upload-belstat/upload-belstat-excel/Oficial_statistika/Prices_goods_10_2016.xlsx'
    data_links['11_2016'] = 'http://www.belstat.gov.by/upload-belstat/upload-belstat-excel/Oficial_statistika/Average%20prices_tov_11_2016.xlsx'
    data_links['12_2016'] = 'http://www.belstat.gov.by/upload-belstat/upload-belstat-word/Oficial_statistika/prices_tov-12-2016.xlsx'
    data_links
  end
  
  def generate_links_2017
    data_links = {}
    data_links['01_2017'] = 'http://www.belstat.gov.by/upload-belstat/upload-belstat-excel/Oficial_statistika/price-01-2017.xlsx'
    data_links['02_2017'] = 'http://www.belstat.gov.by/upload-belstat/upload-belstat-excel/Oficial_statistika/Average_prices_02-2017.xlsx'
    data_links['03_2017'] = 'http://www.belstat.gov.by/upload-belstat/upload-belstat-excel/Oficial_statistika/Average_prices(serv)-03-2017.xlsx'
    data_links['04_2017'] = 'http://www.belstat.gov.by/upload-belstat/upload-belstat-excel/Oficial_statistika/Average_prices(serv)-04-2017.xlsx'
    data_links['05_2017'] = 'http://www.belstat.gov.by/upload-belstat/upload-belstat-word/Oficial_statistika/Average%20prices(serv)-05-2017.xlsx'
    data_links['06_2017'] = 'http://www.belstat.gov.by/upload-belstat/upload-belstat-excel/Oficial_statistika/Average_prices(serv)-06-2017.xls'
    data_links['07_2017'] = 'http://www.belstat.gov.by/upload-belstat/upload-belstat-excel/Oficial_statistika/Average_prices(serv)-07-2017.xlsx'
    data_links['08_2017'] = 'http://www.belstat.gov.by/upload-belstat/upload-belstat-excel/Oficial_statistika/Average_prices(serv)-08-2017.xlsx'
    data_links['09_2017'] = 'http://www.belstat.gov.by/upload-belstat/upload-belstat-excel/Oficial_statistika/Average_prices(serv)-09-2017.xls'
    data_links['10_2017'] = 'http://www.belstat.gov.by/upload-belstat/upload-belstat-excel/Oficial_statistika/Average_prices(serv)-10-2017.xlsx'
    data_links['11_2017'] = 'http://www.belstat.gov.by/upload-belstat/upload-belstat-word/Oficial_statistika/Average%20prices(serv)-11-2017.xlsx'
    data_links['12_2017'] = 'http://www.belstat.gov.by/upload-belstat/upload-belstat-excel/Oficial_statistika/Average%20prices(serv)-12-2017.xlsx'
    data_links
  end
  
  def generate_links_2018
    beg_s = 'http://www.belstat.gov.by/upload-belstat/upload-belstat-excel/Oficial_statistika/Average_prices(serv)-'
    end_s = '-2018.xlsx'
    data_links = {}
    (1..4).each do |e|
      month_number = e < 10 ? '0' + e.to_s : e
      data_links["#{month_number}_2018"] = "#{beg_s}#{month_number}#{end_s}"
    end
    data_links['05_2018'] = 'http://www.belstat.gov.by/upload-belstat/upload-belstat-excel/Oficial_statistika/Average%20prices(serv)-05-2018.xlsx'
    data_links['06_2018'] = 'http://www.belstat.gov.by/upload-belstat/upload-belstat-excel/Oficial_statistika/Average_prices(serv)-06-2018.xlsx'
    data_links['07_2018'] = 'http://www.belstat.gov.by/upload-belstat/upload-belstat-excel/Oficial_statistika/Average%20prices(serv)-07-2018.xlsx'
    (8..10).each do |e|
      month_number = e < 10 ? '0' + e.to_s : e
      data_links["#{month_number}_2018"] = "#{beg_s}#{month_number}#{end_s}"
    end
    data_links
  end
end
