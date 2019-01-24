require 'json'
require 'redis'
require_relative 'url_generator'
require_relative 'scraper_hash_generator'
require_relative 'rhymer'
CONFIG_FILE = JSON.parse(File.read('config.json')).freeze
REDIS_PASSWORD = CONFIG_FILE['pass'].freeze
REDIS_URL = CONFIG_FILE['url'].freeze
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
