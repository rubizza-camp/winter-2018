require_relative 'wordplay_bot'
require_relative 'db_wrapper'
require_relative 'parser.rb'

class Runner
  BASE_PAGES = ['https://www.bydewey.com/pun.html', 'https://www.bydewey.com/pun2.html'].freeze

  def run
    db = DBWrapper.new

    return if check_connection(db).nil?

    fill_database(db) if db.empty?

    bot = WordplayBot.new(db)

    bot.start
  end

  private

  def fill_database(db)
    parser = Parser.new
    wordplays = BASE_PAGES.reduce([]) { |stach, url| stach << parser.parse(url) }

    db.multiple_set(wordplays.flatten)
  end

  def check_connection(db)
    db.ping
  rescue StandardError => e
    puts "check your redis connection \n #{e.message}"
    nil
  end
end
