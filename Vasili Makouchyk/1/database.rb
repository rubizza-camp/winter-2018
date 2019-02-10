require 'redis'
require_relative 'scrape_quotes.rb'

class DataBase

  def initialize
    @database = Redis.new
  end

  def load_quotes
    set_db(ScrapeQuotes.new.scrape_quotes)
  end

  def set_db(quotes)
    quotes.each_with_index do |quote, index|
      @database.set(index, quote.inner_text)
    end
  end

  def random_quote
    @database.get(@database.randomkey)
  end
end
