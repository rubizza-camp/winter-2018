require 'redis'
require './parser'

class Database
  def initialize
    @redis = Redis.new
    @parser = Parser.new.get_wordplay
  end

  def set_data
    (0...@parser.length).each do |i|
      @redis.set(i, @parser[i])
    end
  end

  def get_data
    i = rand(0...@parser.length)
    @redis.get(i)
  end
end
