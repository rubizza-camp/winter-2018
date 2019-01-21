require_relative 'lib/wordplay_bot'
require_relative 'lib/db_wrapper'
require_relative 'lib/parser.rb'

BASE_PAGES = ['https://www.bydewey.com/pun.html', 'https://www.bydewey.com/pun2.html'].freeze

db = DBWrapper.new

begin
  if db.ping
    if db.empty?
      parser = Parser.new
      wordplays = BASE_PAGES.reduce([]) { |stach, url| stach << parser.parse(url) }
      
      db.multiple_set(wordplays.flatten)
    end
  end
rescue StandardError => e
  puts "check your redis connection \n #{e.message}"
  return
end

bot = WordplayBot.new(db)

bot.start
