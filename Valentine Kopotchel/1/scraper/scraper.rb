$LOAD_PATH << '.'
require 'json'
require 'redis'
require 'url_generator.rb'
require 'scraper_hash_generator.rb'
require 'rhymer'
REDIS_PASSWORD = JSON.parse(File.read('config.json'))['pass']
                     .freeze
REDIS_URL = JSON.parse(File.read('config.json'))['url']
                .freeze
BATTLE_LEAGUES_IDS = [1_043_148, 349_224, 1_014_895, 1_148_720,
                      461_389, 1_570_020, 669_868].freeze
# Fills database(remember about config.json!)
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
redis = Redis.new(url: REDIS_URL, password: REDIS_PASSWORD)
redis.set('db', r.wordplays)
