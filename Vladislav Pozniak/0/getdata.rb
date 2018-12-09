require 'nokogiri'
require 'open-uri'
require 'roo'
require 'roo-xls'
require 'addressable/uri'
require 'uri'

MONTHS = { 'январь': '01', 'февраль': '02', 'март': '03',
           'апрель': '04', 'май': '05', 'июнь': '06',
           'июль': '07', 'август': '08', 'сентябрь': '09',
           'октябрь': '10', 'ноябрь': '11', 'декабрь': '12' }.freeze
LINK = 'http://www.belstat.gov.by/ofitsialnaya-statistika/makroekonomika-i-okruzhayushchaya-sreda/tseny/operativnaya-informatsiya_4/srednie-tseny-na-potrebitelskie-tovary-i-uslugi-po-respublike-belarus/'.freeze
YEAR_POS = -2 # Year position in string
MONTH_POS = -3 # Month position in string

page = Nokogiri::HTML(URI.open(LINK))
links = page.css('a[href*="xls"]').map { |a| a['href'] }

Dir.mkdir('data') unless File.directory?('data')
links.each do |link|
  link.prepend('http://www.belstat.gov.by') unless link.start_with? 'http://'
  link = Addressable::URI.escape(link) unless link.include? '%'
  puts "Processing #{link}"
  file_name = link.split('/').last
  IO.copy_stream(URI.open(link), file_name)
  table = Roo::Spreadsheet.open(file, extension: File.extname(file_name))
  year = table.cell(3, 'A').split(' ')[YEAR_POS]
  month = MONTHS[table.cell(3, 'A').split(' ')[MONTH_POS].to_sym]
  File.rename(file, "./data/#{year}.#{month}#{File.extname(file_name)}")
end
