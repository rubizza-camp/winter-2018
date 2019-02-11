require 'telegram/bot'
require 'redis'
require_relative 'parser.rb'

TOKEN = File.read('TELEGRAM_BOT_API.txt')

# Hi there
class Bot
  def initialize
    @bot = Telegram::Bot::Client.new(TOKEN)
    @b = Parser.new
    run
  end

  def start(message)
    start = "Hi there, #{message.from.first_name} " +
    "\n @GovorynBot is there to provide you with best panches," +
    " quites and wordplays\n Use /wordplay command to get a quote" +
    "\n /stop will finish bot process"
    @bot.api.sendMessage(chat_id: message.chat.id, text: start)
  end

  def wordplay(message)
    wordplay = @b.random
    @bot.api.sendMessage(chat_id: message.chat.id, text: wordplay)
  end

  def stop(message)
    @bot.api.sendMessage(chat_id: message.chat.id, text: 'Bye')
  end

  def else_reply(message)
    else_ms = 'Sorry, u did smth wrong, try again,pls'
    @bot.api.sendMessage(chat_id: message.chat.id, text: else_ms)
  end

  def work(message)
    case message.text
    when '/start'
      start(message)
    when '/wordplay'
      wordplay(message)
    when '/stop'
      stop(message)
    else
      else_reply(message)
    end
  end

  def run
    @bot.listen do |message|
      work(message)
    end
  end
end

Bot.new
