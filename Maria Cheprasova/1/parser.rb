# fgkjl
require 'nokogiri'
require 'open-uri'
require 'redis'

# Hi there
class Parser
    URL = 'https://examples.yourdictionary.com/examples-of-puns.html'.freeze
    def initialize
    @wp = []
    @db = Redis.new
    parse
    add_all_puns
  end

  def parse
    doc = Nokogiri::HTML(URI.open(URL))
    @wp = doc.css('#article_intro ul li').map(&:content)
    @wp = doc.css('#article_body ul li').map(&:content)
    @wp.reverse!
    @wp.slice!(0..2)
  end

  def add_all_puns
    @wp.each_with_index { |value, id| @db.set(id, value) }
  end

  def random
    @db.get(@db.RANDOMKEY)
  end
end
