# 

require 'nokogiri'
require 'mechanize'
require 'redis'
require 'json'

class DataBase
  def initialize
    @url = 'http://rapstyle.su/quotes.php'.freeze
    @database = Redis.new
  end

  def download_page
    agent = Mechanize.new
    page = agent.get(@url)
    File.write('citaty.html', page.body)
  end

  def scrape_quotes
    page = Nokogiri::HTML(File.read('citaty.html'))
    quotes = page.css('.post-entry p')
    quotes.each_with_index do |quote, index|
      @database.set(String(index), quote.inner_text.to_json)
      # puts "added #{quote.inner_text}"
    end
  end

  def random_quote
    @database.get(@database.randomkey)
  end
end

db = DataBase.new
db.get_quotes
