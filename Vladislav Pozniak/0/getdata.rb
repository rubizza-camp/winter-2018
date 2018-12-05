require 'nokogiri'
require 'open-uri'
require 'roo'
require 'roo-xls'
require 'addressable/uri'
require 'uri'

months = { 'январь': '01', 'февраль': '02', 'март': '03', 'апрель': '04',
           'май': '05', 'июнь': '06', 'июль': '07', 'август': '08',
           'сентябрь': '09', 'октябрь': '10', 'ноябрь': '11', 'декабрь': '12' }
page = Nokogiri::HTML(open('http://www.belstat.gov.by/ofitsialnaya-statistika/makroekonomika-i-okruzhayushchaya-sreda/tseny/operativnaya-informatsiya_4/srednie-tseny-na-potrebitelskie-tovary-i-uslugi-po-respublike-belarus/'))
links = page.css('a[href*="xls"]').map { |a| a['href'] }

links.each do |link|
  link.prepend('http://www.belstat.gov.by') if link[0] == '/'
  link = Addressable::URI.escape(link) unless link.include? '%'
  puts 'Processing' + link
  file = link.split('/')[-1]
  IO.copy_stream(URI.open(link), file)
  table = Roo::Spreadsheet.open(file, extension: File.extname(file))
  year = table.cell(3, 'A').split(' ')[-2]
  month = months[table.cell(3, 'A').split(' ')[-3].to_sym]
  File.rename(file, ('./data/' + year + '.' + month + File.extname(file)))
end
