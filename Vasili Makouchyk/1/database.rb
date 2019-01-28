#

require 'nokogiri'
require 'mechanize'
require 'redis'
require 'json'

class DataBase
  def initialize
    @url = 'http://rapstyle.su/quotes.php'.freeze
    @db = Redis.new
  end

  def get_page
    agent = Mechanize.new
    page = agent.get(@url)
    File.write('citaty.html', page.body)
  end

  def get_quotes
    page = Nokogiri::HTML(File.read('citaty.html'))
    quotes = page.css('.post-entry p')
    quotes.each_with_index do |quote, index|
      @db.set String(index), quote.inner_text.to_json
      #puts "added #{quote.inner_text}"
    end
  end

  def get_random_quote
    @db.get(@db.randomkey)
  end
end

db = DataBase.new
db.get_quotes
