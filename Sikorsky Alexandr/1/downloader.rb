require 'open-uri'
require 'nokogiri'
require 'pry-byebug'
require_relative 'base'

base_pages = ['https://www.bydewey.com/pun.html', 'https://www.bydewey.com/pun2.html'].freeze

def parse(url)
  page = Nokogiri::HTML(URI.parse(url).open)
  binding.pry
  raw_wordplays = page.xpath('//p').map(&:text)
  clean(raw_wordplays)
end

def clean (raw_list)
  raw_wordplays = raw_list.reject{|p| !p.match?(/^\d+\./)}
  wordplays = a.map { |p| p[/\.\s([^~]+)/, 1].strip }
  #a.map { |p| p.match?(/\s~\s/) ? p.split(' ~ ').first : p}
end

if $PROGRAM_NAME == __FILE__
  wordplays = base_pages.reduce([]) { |wordplays, url| wordplays << parse(url) }
  db_wrapper = DBWrapper.new
  db_wrapper.multiple_set(ps.flatten)

  rand = db_wrapper.random_record
end


