require 'open-uri'
require 'nokogiri'
require 'pry'

module  BelStat
  class Downloader
    def initialize
      @url = 'http://www.belstat.gov.by/'\
       'ofitsialnaya-statistika/'\
       'makroekonomika-i-okruzhayushchaya-sreda/'\
       'tseny/operativnaya-informatsiya_4/'\
       'srednie-tseny-na-potrebitelskie-tovary'\
       '-i-uslugi-po-respublike-belarus/'

      @domain = 'http://www.belstat.gov.by'
    end

    def download_excels(directory_name)
      docs_urls = parse(@url)

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
        File.open(path, 'wb') do |file|
          file << URI.parse(url).open.read
        end
      rescue StandardError => exception
        puts 'download ' + exception.message
      end
    end

    def parse(url)
      page = Nokogiri::HTML(URI.parse(url).open)
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
      len = digits.length
      return "#{digits[0..1]}.20#{digits[2, 3]}" if len == 4
      return "#{digits[0..1]}.#{digits[2..5]}" if [6, 7].include?(len)
      return "#{digits[2..3]}.#{digits[4..-1]}" if len == 8

      digits
    end
  end
end
