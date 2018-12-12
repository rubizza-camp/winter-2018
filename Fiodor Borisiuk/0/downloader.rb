require 'bundler/setup'
Bundler.require(:default)

require 'open-uri'
require 'net/http'

def check_data
  system('mkdir .data') if Dir['./data'].nil?
end

url = 'http://www.belstat.gov.by/ofitsialnaya-statistika/makroekonomika-i-okruzhayushchaya-sreda/tseny/operativnaya-informatsiya_4/srednie-tseny-na-potrebitelskie-tovary-i-uslugi-po-respublike-belarus'
html = URI.parse(url).open.read

doc = Nokogiri::HTML(html).to_s
ind_low = doc.index('СРЕДНИЕ ЦЕНЫ НА ТОВАРЫ, РЕАЛИЗУЕМЫЕ В РОЗНИЧНОЙ СЕТИ')
ind_high_def = doc.index('Средние цены (тарифы) на отдельные виды платных')
doc = doc[ind_low..ind_high_def]

months = %w[янв фев мар апр май июн июл авг сен окт ноя дек]
url_table = {}
f = true
while f
  ind_low = doc.index('<a href="')
  ind_high = doc.index('</a>')
  if ind_low && ind_high
    str = doc[ind_low..ind_high]
    ind = str.index('за')
    break if ind.nil?

    month = months.index(str[ind + 3..ind + 5]) + 1

    ind = str.index('200')
    ind = str.index('201') if ind.nil?
    break if ind.nil?

    year = str[ind..ind + 3]
    date = if month < 10
             '0'
           else
             ''
           end
    date += month.to_s + '-' + year
    url = str[str.index('"') + 1..str.index('>') - 2]
    url_table[date] = url
    doc = doc[ind_high + 2..ind_high_def]
  else
    f = false
  end
end

url_table.keys.each do |key|
  Net::HTTP.start('www.belstat.gov.by') do |http|
    resp = http.get(url_table[key])
    xls_form = if url_table[key].index('xlsx').nil?
                 'xls'
               else
                 'xlsx'
               end
    open("./.data/ex#{key}.#{xls_form}", 'wb') { |file| file.write(resp.body) }
    puts "downloaded ex#{key}.#{xls_form}"
  end
end
