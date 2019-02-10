require 'nokogiri'
require 'mechanize'

class ScrapeQuotes
  URL = 'http://rapstyle.su/quotes.php'.freeze
  FILE = 'citaty.html'.freeze

  def initialize
    download_page
  end

  def download_page
    agent = Mechanize.new
    page = agent.get(URL)
    File.write(FILE, page.body)
  end

  def scrape_quotes
    page = Nokogiri::HTML(File.open(FILE))
    page.css('.post-entry p')
  end
end
