# frozen_string_literal: true

require 'nokogiri'
require 'open-uri'
require 'redis'

# Needed jobs with database
class Db
  URL_BASE = 'https://www.punoftheday.com/pun/'.freeze # Site with puns
  MIN_ID = 1 # First pun's ID in range to parse
  MAX_ID = 5000 # Last pun's ID in range to parse

  def initialize
    @db_size = 10 # Number of puns to parse
    @db = Redis.new
  end

  def up?
    !@db.ping.nil?
  end

  def empty?
    @db.dbsize.zero?
  end

  def random_select
    @db.get(@db.randomkey)
  end

  def flush
    puts 'Flushing database...'
    @db.flushall
  end

  def fill
    puts 'Filling database...'
    @db_size.times do
      id = rand(MIN_ID..MAX_ID).to_s
      url = URL_BASE + id
      pun = Nokogiri::HTML(URI.open(url)).at('p').text
      @db.set(id, pun)
      puts "- Added pun ##{id}"
    end
  end
end
