require 'telegram/bot'
require './database.rb'

TELEGRAM_BOT_TOKEN = '603660924:AAFQSiTlEJNAh1zCt4MgwAkCZt1rprEebjc'.freeze

class MyBot
  def initialize
    @database = Database.new
  end

  def start_listen
    Telegram::Bot::Client.run(TELEGRAM_BOT_TOKEN) do |bot|
      bot.listen do |message|
        case message.text
        when '/start'
          message(bot,message, "Здарова #{message.from.first_name}")
          @question = 'Нажми:'
          @answers = Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: %w(/wordplay), one_time_keyboard: true)
          bot.api.send_message(chat_id: message.chat.id, text: @question, reply_markup: @answers)
        when '/wordplay'
          message(bot, message, db)
        else
          message(bot, message, 'Нажми на /wordplay')
        end
      end
    end
  end

  def db
    @database.getdata
  end

  def message(bot, message, text)
    bot.api.send_message(chat_id: message.chat.id, text: text)
  end
end
MyBot.new.start_listen
