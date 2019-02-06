class TelegramBot
  require 'telegram/bot'
  require_relative 'database.rb'

  TOKEN = '763048036:AAFYPEP6nUfC8bpOD6XpiYrnrUOe031sIow'.freeze

  def initialize
    @db = DataBase.new
    @bot = Telegram::Bot::Client.new(TOKEN)
    run
  end

  def run
    @bot.listen do |message|
      listen(message)
    end
  end

  def listen(message)
    case message.text
    when '/start'
      start(message)
    when '/wordplay'
      worldplay(message)
    when '/help'
      help(message)
    else
      default(message)
    end
  end

  def stop(message)
    stop = "Bye, bro #{message.from.first_name}"
    @bot.api.send_message(chat_id: message.chat.id, text: stop)
  end

  def worldplay(message)
    wordplay = "Take this: #{@db.random_quote}"
    @bot.api.send_message(chat_id: message.chat.id, text: wordplay)
  end

  def start(message)
    start = "Hello, #{message.from.first_name}, try /help"
    @bot.api.send_message(chat_id: message.chat.id, text: start)
  end

  def help(message)
    help = "/wordplay\n/start\n/stop"
    @bot.api.send_message(chat_id: message.chat.id, text: help)
  end

  def default(message)
    default = "Sry, #{message.from.first_name}, I don't know what do you want from me (｡-人-｡)."
    @bot.api.send_message(chat_id: message.chat.id, text: default)
  end
end

TelegramBot.new
