require 'redis'

class DBWrapper
  def initialize
    @redis = Redis.new
  end

  def multiple_set(values)
    records = values.each_with_index.map { |value, index| [index, value] }
    @redis.msetnx(records.flatten)
  end

  def random_record
    @redis.get(@redis.randomkey)
  end
end
