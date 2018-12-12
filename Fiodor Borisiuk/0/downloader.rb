require 'bundler/setup'
Bundler.require(:default)

require 'open-uri'
require 'net/http'

URL = 'http://www.belstat.gov.by/ofitsialnaya-statistika/makroekonomika-i-okruzhayushchaya-sreda/tseny/operativnaya-informatsiya_4/srednie-tseny-na-potrebitelskie-tovary-i-uslugi-po-respublike-belarus'.freeze
KEY_IND_LOW = 'СРЕДНИЕ ЦЕНЫ НА ТОВАРЫ, РЕАЛИЗУЕМЫЕ В РОЗНИЧНОЙ СЕТИ'.freeze
KEY_IND_HIGH_DEF = 'Средние цены (тарифы) на отдельные виды платных'.freeze
MONTHS = %w[янв фев мар апр май июн июл авг сен окт ноя дек].freeze

html = URI.parse(URL).open.read

doc = Nokogiri::HTML(html).to_s

ind_low = doc.index(KEY_IND_LOW)
ind_high_def = doc.index(KEY_IND_HIGH_DEF)
doc = doc[ind_low..ind_high_def]

url_table = {}
loop do
  ind_low = doc.index('<a href="')
  ind_high = doc.index('</a>')
  break unless ind_low && ind_high

  str = doc[ind_low..ind_high]
  ind = str.index('за')
  break if ind.nil?

  month = MONTHS.index(str[ind + 3..ind + 5]) + 1

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
  url_table[date] = str[str.index('"') + 1..str.index('>') - 2]
  doc = doc[ind_high + 2..ind_high_def]
end

url_table.keys.each do |key|
  Dir.mkdir('./.data') unless File.directory?('./.data')
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
