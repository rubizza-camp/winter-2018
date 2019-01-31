# fgkjl
require 'nokogiri'
require 'open-uri'
require 'redis'

URL = 'https://examples.yourdictionary.com/examples-of-puns.html'.freeze

# Hi there
class Parser
  def initialize
    @wp = []
    @db = Redis.new
    parse
    add_all_puns
  end

  def parse
    doc = Nokogiri::HTML(URI.open(URL))
    doc.css('#article_intro ul li').each do |link|
      @wp.push(link.content)
    end
    doc.css('#article_body ul li').each do |link|
      @wp.push(link.content)
    end
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
