require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'redis'

class PunParser
  BASE_URL = 'https://onelinefun.com'.freeze

  def run
    while true do
      puts "Parsing #{@link}"
      page = parse_page
      @link = find_next_page_link(page)
      break unless @link
    end
    save_puns_to_redis
  end

  def initialize
    @link = '/puns/'
    @redis = Redis.new
    @puns = []
  end

  private

  def parse_page
    url = BASE_URL + @link
    page = Nokogiri::HTML(open(url))
    page.css('article div p').each do |p|
      pun = p.text
      @puns << pun
      end
    page
  end

  def find_next_page_link(page)
    a_next = page.css('article div.p > a')
    @link = if a_next && a_next.text =~ /^next/i
      a_next.attr('href').value
    else
      nil
    end
    @link
  end

  def save_puns_to_redis
    @puns.each_with_index do |pun, i|
      @redis.set("pun_#{i}", pun)
    end
  end
end
