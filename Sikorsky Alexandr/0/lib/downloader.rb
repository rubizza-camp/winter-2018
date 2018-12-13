require 'open-uri'
require 'nokogiri'

module  BelStat
  class Downloader
    MAIN_URL = 'http://www.belstat.gov.by/ofitsialnaya-statistika/makroekonomika-i-okruzhayushchaya-sreda/tseny/operativnaya-informatsiya_4/srednie-tseny-na-potrebitelskie-tovary-i-uslugi-po-respublike-belarus/'.freeze

    DOMAIN = 'http://www.belstat.gov.by'.freeze

    def download_excels(directory_name)
      docs_urls = parse(MAIN_URL)

      docs_urls.each do |url|
        url = url.to_s
        url = DOMAIN + url unless url.start_with? 'http'

        puts url
        puts '------------'

        download(url, url.split('/').last, "./#{directory_name}")
      end
    end

    private

    def download(url, file_name, folder)
      path = File.join(folder, file_name)
      begin
        content = URI.parse(url).open.read
        File.write(path, content)
      rescue StandardError => exception
        puts 'download ' + exception.message
      end
    end

    def parse(url)
      page = Nokogiri::HTML(URI.parse(url).open)
      rows = page.xpath('//td//a/@href')
      rows.select { |r| r.to_s.include? 'xls' }
    end
  end
end

if $PROGRAM_NAME == __FILE__
  downloader = BelStat::Downloader.new
  downloader.download_excels 'raw_data'
end
