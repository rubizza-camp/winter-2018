require 'yaml'
require_relative 'wordplay_bot'
require_relative 'db_wrapper'
require_relative 'parser.rb'

class Runner
  BASE_PAGES = ['https://www.bydewey.com/pun.html', 'https://www.bydewey.com/pun2.html'].freeze
  CONFIG_FILE_PATH = 'config.yaml'.freeze

  def run
    database = DBWrapper.new

    return if check_connection(database).nil?

    fill_database(database) if database.empty?

    token = load_token

    raise 'empty token' if token.nil?

    bot = WordplayBot.new(database, token)

    bot.start
  end

  private

  def fill_database(database)
    parser = Parser.new

    wordplays = BASE_PAGES.flat_map { |url| parser.parse(url) }
    database.multiple_set(wordplays)
  end

  def check_connection(database)
    database.ping
  rescue StandardError => e
    puts "check your redis connection \n #{e.message}"
    raise
  end

  def load_token
    config = YAML.load_file(CONFIG_FILE_PATH)
    config.dig('credentials', 'token')
  rescue Errno::ENOENT
    puts 'missing config file'
    raise
  end
end
