require 'mechanize'
require 'open-uri'
require 'roo'
require 'addressable/uri'
require 'roo-xls'

URL = 'http://www.belstat.gov.by/ofitsialnaya-statistika/makroekonomika'\
'-i-okruzhayushchaya-sreda/tseny/operativnaya-informatsiya_4/srednie-tseny'\
'-na-potrebitelskie-tovary-i-uslugi-po-respublike-belarus/'.freeze
CSS_SELECTOR = '.table>table>tbody'.freeze
PATH_FOR_DATA = './data'.freeze
MONTHS = %w[январь февраль март апрель май июнь июль август
            сентябрь октябрь ноябрь декабрь].freeze

def create_file_by_uri(uri, rename, filename: uri.split('/')[-1],
                       new_path: '.')
  uri = Addressable::URI.escape(uri) unless uri.include?('%')
  IO.copy_stream(URI.open(uri), filename)
  rename_file(filename, new_path) if rename
end

def rename_file(filename, new_path)
  spreadsheet = open_spreadsheet(filename)
  new_filename = create_new_name_for_file(spreadsheet)
  File.rename(filename, new_path + '/' + new_filename + File.extname(filename))
end

def open_spreadsheet(filename)
  Roo::Spreadsheet.open(filename, extension: File.extname(filename))
end

def create_new_name_for_file(spreadsheet)
  spreadsheet.cell(3, 'A').split(' ')[-2] + '.' +
    (MONTHS.index(spreadsheet.cell(3, 'A').split(' ')[-3]) + 1).to_s
end

def create_links_list(table)
  links = []
  table.search('a').each do |link|
    link = if link['href'][0] == '/'
             'http://www.belstat.gov.by' + link['href']
           else
             link['href']
           end
    links << link
  end
  links
end

def download_data
  agent = Mechanize.new
  Dir.mkdir('data') unless Dir.exist?(PATH_FOR_DATA)
  table = agent.get(URL).search(CSS_SELECTOR).first
  puts 'Creating links list.'
  links = create_links_list(table)
  puts 'Creating and writing files.'
  links.each do |link|
    create_file_by_uri(link, true, new_path: PATH_FOR_DATA)
  end
  puts 'Done.'
end
