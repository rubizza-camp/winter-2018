require 'open-uri'
require 'nokogiri'
require 'pry'

def gener_name(uri)
  sub_str = uri.split('/')[-1]
  part1 = sub_str.gsub(/\D/, '')

  if part1.length == 4
    part1 = part1[0..1] + '.20' + part1[2, 3]
  elsif part1.length == 6 || part1.length == 7
    part1 = part1[0..1] + '.' + part1[2..5]
  elsif part1.length == 8
    part1 = part1[2..3] + '.' + part1[4..-1]
  end

  part1 + '.' + sub_str.split('.')[-1]
end

def download(uri, file_name, folder)
  path = folder + '/' + file_name
  begin
    open(path, 'wb') do |file|
      file << open(uri).read
    end
  rescue StandardError => exception
    puts 'err'
  end
end

def parse(uri)
  page = Nokogiri::HTML(open(uri))
  rows = page.xpath('//td//a/@href')
  rows.select { |r| r.to_s =~ /xls(.*)$/ }
end

def load_excels
  l = parse('http://www.belstat.gov.by/ofitsialnaya-statistika/makroekonomika-i-okruzhayushchaya-sreda/tseny/operativnaya-informatsiya_4/srednie-tseny-na-potrebitelskie-tovary-i-uslugi-po-respublike-belarus/')

  l.each do |a|
    a = a.to_s
    a = 'http://www.belstat.gov.by' + a unless a =~ /http(.*)/
    puts a
    puts gener_name a
    puts '------------'
    download(a, gener_name(a), './raw_data')
  end
end

load_excels