require 'open-url'
require 'nokogiri'
require 'pry'

module  BelStat
  class Downloader
    def initialize
      @URL = 'http://www.belstat.gov.by/'\
       'ofitsialnaya-statistika/'\
       'makroekonomika-i-okruzhayushchaya-sreda/'\
       'tseny/operativnaya-informatsiya_4/'\
       'srednie-tseny-na-potrebitelskie-tovary'\
       '-i-uslugi-po-respublike-belarus/'
    end

    def download_excels
      l = parse(@URL)

      l.each do |a|
        a = a.to_s
        a = 'http://www.belstat.gov.by' + a unless a =~ /http(.*)/
        puts a
        puts generate_name a
        puts '------------'
        download(a, generate_name(a), './raw_data')
      end
    end

    private

    def download(url, file_name, folder)
      path = folder + '/' + file_name
      begin
        open(path, 'wb') do |file|
          file << open(url).read
        end
      rescue StandardError => exception
        puts 'download ' + exception.message
      end
    end

    def parse(url)
      page = Nokogiri::HTML(open(url))
      rows = page.xpath('//td//a/@href')
      rows.select { |r| r.to_s =~ /xls(.*)$/ }
    end

    def generate_name(url)
      sub_str = url.split('/')[-1]
      digits = sub_str.gsub(/\D/, '')

      date = digits2date(digits)

      date + '.' + sub_str.split('.')[-1]
    end

    def digits2date(digits)
      if digits.length == 4
        digits[0..1] + '.20' + digits[2, 3]
      elsif digits.length == 6 || digits.length == 7
        digits[0..1] + '.' + digits[2..5]
      elsif digits.length == 8
        digits[2..3] + '.' + digits[4..-1]
      end
    end
  end
end
