require 'redis'
require './parser'

class Database
  def initialize
    @redis = Redis.new
    @parser = Parser.new.getwordplay
  end

  def setdata
    (0...@parser.length).each do |i|
      @redis.set(i, @parser[i])
    end
  end

  def getdata
    i = rand(0...@parser.length)
    @redis.get(i)
  end
end
