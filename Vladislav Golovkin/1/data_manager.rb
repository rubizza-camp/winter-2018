require 'mechanize'
require 'redis'

URL_FUNNY_PUNS = 'https://thoughtcatalog.com/january-nelson/2018/03/50-short-funny-puns-that-will-crack-you-up-in-five-seconds-flat/'.freeze
URL_DAD_JOKES = 'http://pun.me/pages/dad-jokes.php'.freeze

# class for collecting data and writing it to redis
class DataManager
  def initialize
    @redis = Redis.new
    @key_counter = 0
    @scrapper = Mechanize.new
  end

  # adds entry to redis
  def add_entry(string)
    @key_counter += 1
    @redis.set(@key_counter.to_s, string)
  end

  # get entry by key from redis
  def get_entry(key)
    @redis.get(key)
  end

  # get random value from redis
  def random_rofl
    get_entry(rand(0..@key_counter).to_s)
  end

  # call your parsing dcripts here
  def collect_data
    puts 'Collecting data...'
    collect_funny_puns
    collect_dads_jokes
    puts 'Collecting data...finished'
  end

  def collect_funny_puns
    page = @scrapper.get(URL_FUNNY_PUNS)

    raw_h4 = page.search("div[@class='entry-block-group box-content'] h4")
    raw_p = page.search("div[@class='entry-block-group box-content'] p")

    rdy_h4 = []
    raw_h4.each { |element| rdy_h4 << element.text.gsub(/\d+\. /, '') }
    raw_p.each_with_index { |element, index| add_entry(rdy_h4[index] + ' ' + element.text) }
  end

  def collect_dads_jokes
    page = @scrapper.get(URL_DAD_JOKES)
    raw_li = page.search('ol li')
    raw_li.each { |element| add_entry(element.text) }
  end
end
