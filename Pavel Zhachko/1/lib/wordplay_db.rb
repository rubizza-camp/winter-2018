require 'redis'
require_relative 'scrapper'

# Database for wordplays
class Database
  def initialize
    @db = Redis.new
  end

  def wordplays_from_page(page)
    Scrapper.wordplay_test(page).each do |el|
      @db.rpush('wordplay:db:key', el.text)
    end
  end

  def random_wordplay
    @db.lindex('wordplay:db:key', rand(@db.llen('wordplay:db:key')))
  end

  def keys?
    @db.keys
  end

  def clear_db_key(*keys)
    @db.del(*keys)
  end
end
