require 'mechanize'
require 'nokogiri'

# Module for scrap some wordplays from page
module Scrapper
  def self.wordplay_test(page)
    Mechanize.new.get(page).xpath('//main/article/div/ol/li').xpath('text()')
  end
end
