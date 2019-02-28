require 'redis'
require_relative 'parser'

# redis db
class DB
  def initialize
    @redis = Redis.new
    @sc = Scraper.new.wordplay
  end

  def check_ping
    @redis.ping
  end

  def store
    (0...@sc.length).each do |i|
      @redis.set(i, @sc[i])
    end
  end

  def getdata
    i = rand(0...@sc.length)
    @redis.get(i)
  end
end
