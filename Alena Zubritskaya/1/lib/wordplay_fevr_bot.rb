require 'telegram/bot'
require './database.rb'

class MyBot
  def initialize
    @token = '603660924:AAFQSiTlEJNAh1zCt4MgwAkCZt1rprEebjc'
    @database = Database.new
  end

  def start_listen
    Telegram::Bot::Client.run(@token) do |bot|
      bot.listen do |message|
        choice(bot, message)
      end
    end
  end

  def db
    @database.getdata
  end

  def message(bot, message, text)
    bot.api.send_message(chat_id: message.chat.id, text: text)
  end

  # def keyboard(bot, message, text, keybrd)
  #   @answers = Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: %w(/wordplay), one_time_keyboard: true)
  #   bot.api.send_message(chat_id: message.chat.id, text: text, reply_markup: ReplyKeyboardMarkup)
  # end

  def choice(bot, message)
    case message.text
    when '/start'
      message(bot, message, "Здарова #{message.from.first_name}")
      @question = 'Нажми:'
      @answers = Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: %w(/wordplay), one_time_keyboard: true)
      bot.api.send_message(chat_id: message.chat.id, text: @question, reply_markup: @answers)
      # keyboard(bot, message, 'Нажми:', @answers)
    when '/wordplay'
      message(bot, message, db)
    else
      message(bot, message, 'Нажми на /wordplay')
    end
  end
end
MyBot.new.start_listen
