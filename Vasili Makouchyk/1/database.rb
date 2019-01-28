# 

require 'nokogiri'
require 'mechanize'
require 'redis'
require 'json'

URL = 'http://rapstyle.su/quotes.php'.freeze

class DataBase
  def initialize
    @database = Redis.new
  end

  def download_page
    agent = Mechanize.new
    page = agent.get(URL)
    File.write('citaty.html', page.body)
  end

  def scrape_quotes
    page = Nokogiri::HTML(File.read('citaty.html'))
    quotes = page.css('.post-entry p')
    quotes.each_with_index do |quote, index|
      @database.set(String(index), quote.inner_text.to_json)
    end
  end

  def random_quote
    @database.get(@database.randomkey)
  end
end

db = DataBase.new
db.get_quotes
