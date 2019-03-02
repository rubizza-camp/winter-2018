require 'redis'
require './parser'

class Database
  def initialize
    @redis = Redis.new
    @parser = Parser.new.getwordplay
  end

  def setdata
    0.upto(@parser.length) { |i| @redis.set(i, @parser[i]) }
  end

  def getdata
    i = rand(@parser.length)
    @redis.get(i)
  end
end
