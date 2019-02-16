require 'nokogiri'
require 'httparty'

# parse page
class Scraper
  def initialize
    s = HTTParty.get('https://examples.yourdictionary.com/examples-of-puns.html')
    @parse_page ||= Nokogiri::HTML(s)
    @wrd = []
  end

  def wordplay
    @parse_page.css('div#article_intro').css('li').each { |n| @wrd << n.text }
    unless @parse_page.css('div#article_body').css('li').css('a')
      @parse_page.css('div#article_body').css('li').each { |n| @wrd << n.text }
    end
    @wrd
  end
end
