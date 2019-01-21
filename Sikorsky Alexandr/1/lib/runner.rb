require_relative 'wordplay_bot'
require_relative 'db_wrapper'
require_relative 'parser.rb'

class Runner
  BASE_PAGES = ['https://www.bydewey.com/pun.html', 'https://www.bydewey.com/pun2.html'].freeze

  def run
    database = DBWrapper.new

    return if check_connection(database).nil?

    fill_database(database) if db.empty?

    bot = WordplayBot.new(database)

    bot.start
  end

  private

  def fill_database(_database)
    parser = Parser.new
    wordplays = BASE_PAGES.reduce([]) { |stach, url| stach << parser.parse(url) }

    db.multiple_set(wordplays.flatten)
  end

  def check_connection(database)
    database.ping
  rescue StandardError => e
    puts "check your redis connection \n #{e.message}"
    nil
  end
end
