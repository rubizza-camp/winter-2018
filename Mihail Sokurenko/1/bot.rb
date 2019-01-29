require 'telegram/bot'
require_relative 'db'

# this is bot
class Bot
  def initialize
    @token = '764108158:AAGennGjr9eC9MO35OGL0jJ4zWFs-s6Uork'
    @db = DB.new
  end

  def work
    Telegram::Bot::Client.run(@token) do |bot|
      bot.listen do |message|
        choice(bot, message)
      end
    end
  end

  def dbwork
    if !@db.check_ping.nil?
      @db.store
      @db.getdata
    else puts 'Cannot connect'
    end
  end

  def bot_mes(bot, mes, txt)
    bot.api.send_message(chat_id: mes.chat.id, text: txt)
  end

  def choice(bot, message)
    case message.text
    when 'Hey bot!'
      bot_mes(bot, message, 'Hello Master!')
    when '/wordplay' then
      bot_mes(bot, message, 'Random wordplay:')
      bot_mes(bot, message, dbwork)
    else
      bot_mes(bot, message, 'Sorry I can\'t perform ur desire')
    end
  end
end

Bot.new.work
