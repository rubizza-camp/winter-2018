require 'telegram/bot'
require_relative 'db'

# this is bot
class Bot
  def initialize
    @token = File.read('token.bot').chomp
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
