require 'open-uri'
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

      @domain = 'http://www.belstat.gov.by'
    end

    def download_excels(directory_name)
      docs_urls = parse(@URL)

      docs_urls.each do |url|
        url = url.to_s
        url = @domain + url unless url =~ /http(.*)/

        puts url
        puts '------------'

        download(url, generate_name(url), "./#{directory_name}")
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
      else
        digits
      end
    end
  end
end