require 'open-uri'
require 'nokogiri'
require 'pry-byebug'

wordplays_base = ['https://www.bydewey.com/pun.html', 'https://www.bydewey.com/pun2.html'].freeze

def parse(url)
  page = Nokogiri::HTML(URI.parse(url).open)
  page.xpath('//p').map(&:text)
end

binding.pry

ps = wordplays_base.reduce([]) { |base, url| base << parse(url) }
ps.flatten!
