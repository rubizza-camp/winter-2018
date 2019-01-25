require 'rubygems'
require 'json'
require 'redis'
require_relative 'url_generator'
require_relative 'scraper_hash_generator'
require_relative 'rhymer'

# Fills database(remember about config.json!)
class Scraper
  include URLGenerator
  include ScraperHashGenerator
  BATTLE_LEAGUES_IDS = [1_043_148, 349_224, 1_014_895, 1_148_720,
                        461_389, 1_570_020, 669_868].freeze
  attr_accessor :lyrics

  def initialize
    @songs = songs_link_gen(BATTLE_LEAGUES_IDS)
    @lyrics = lyrics_hash_gen(@songs)
  end
end

def config_init
  file = JSON.parse(File.read('config.json')).freeze
  redis_password = file['pass'].freeze
  redis_url = file['url'].freeze
  [redis_password, redis_url]
end

def main
  redis_password, redis_url = config_init
  s = Scraper.new
  r = Rhymer.new(s.lyrics)
  redis = Redis.new(url: redis_url, password: redis_password)
  redis.set('db', r.wordplays.to_json)
end

main if $PROGRAM_NAME == __FILE__
