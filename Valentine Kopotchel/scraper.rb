$LOAD_PATH << '.'
require 'redis'
require 'url_generator.rb'
require 'scraper_hash_generator.rb'
require 'rhymer'
REDIS_PASSWORD = 'jfoKUwriQiC8UD69COeck7qEOJpPygU3'
REDIS_URL="redis://redis-11348.c91.us-east-1-3.ec2.cloud.redislabs.com:11348"
BATTLE_LEAGUES_IDS = [1_043_148, 349_224, 1_014_895, 1_148_720,
                      461_389, 1_570_020, 669_868].freeze
class Scraper
  include URLGenerator
  include ScraperHashGenerator
  attr_accessor :lyrics

  def initialize
    @songs = songs_link_gen(BATTLE_LEAGUES_IDS)
    @lyrics = lyrics_hash_gen(@songs)
  end

end

s = Scraper.new
r = Rhymer.new(s.lyrics)
redis = Redis.new(url: "redis://redis-11348.c91.us-east-1-3.ec2.cloud.redislabs.com:11348", password: REDIS_PASSWORD)
redis.set("db", r.wordplays)