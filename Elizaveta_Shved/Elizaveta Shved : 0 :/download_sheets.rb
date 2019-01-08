require 'rubygems'
require 'faraday'
require 'nokogiri'
require 'open-uri'

MONTHES = { 'январь': '01', 'февраль': '02', 'март': '03', 'апрель': '04', 'май': '05', 'июнь': '06',
            'июль': '07', 'август': '08', 'сентябрь': '09', 'октябрь': '10', 'ноябрь': '11', 'декабрь': '12' }.freeze
PARSING_URL = 'http://www.belstat.gov.by/ofitsialnaya-statistika/makroekonomika-i-okruzhayushchaya-sreda/tseny/operativnaya-informatsiya_4/srednie-tseny-na-potrebitelskie-tovary-i-uslugi-po-respublike-belarus/'.freeze
SITE_URL = 'http://www.belstat.gov.by'.freeze

class DownloadSheets
  def perform_data
    puts 'Download files:'
    links = get_data
    links.each do |date, link|
      puts "Perform #{date}"
      type = link.index('xlsx').nil? ? 'xls' : 'xlsx'
      download_file(date, generate_link(link), type)
    end
  end

  private

  def generate_link(link)
    link = "#{SITE_URL}#{link}" unless link.include?(SITE_URL)
    URI.encode(link)
  end

  def get_data
    file_links = get_file_links
    data_links = {}
    file_links.each do |link|
      file_link = link.attributes['href'].value
      year = find_year(file_link)
      next if year.nil?

      month_key = link.children.first.text[3..-1]
      month_value = MONTHES[month_key.to_sym]
      data_links["#{month_value}_#{year}"] = file_link
    end
    data_links
  end

  def get_file_links
    site_link = PARSING_URL
    page = Faraday.get(site_link)
    html = Nokogiri::HTML(page.body)
    html.css('.l-main').css('.table').first.css('a')
  end

  def find_year(link)
    max_count_iteration = 1
    result = loop do
      index = link.index('20')
      return nil if index.nil? || max_count_iteration > 5
      return link[index..index + 3] unless link[index..index + 3].match(/^(\d)+$/).nil?

      link = link[index + 4..-1]
      max_count_iteration += 1
    end
    result
  end

  def download_file(date, link, type)
    response = Faraday.get(link)
    File.write("./data/#{date}.#{type}", response.body)
  end
end