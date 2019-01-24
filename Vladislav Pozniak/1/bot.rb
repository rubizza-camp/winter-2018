# frozen_string_literal: true

require 'telegram/bot'

require_relative 'db.rb'

# Telegram bot
class Bot
  def initialize(database)
    @token = File.read('bot.token')
    @bot = Telegram::Bot::Client.new(@token)
    @db = database
    puts 'Bot is started, enjoy!'
    run
  end

  def reply(message)
    case message.text
    when 'Hey bot!'
      @bot.api.send_message(chat_id: message.chat.id, text: 'Hey bro!')
    when '/wordplay'
      @bot.api.send_message(chat_id: message.chat.id, text: @db.random_select)
    else
      @bot.api.send_message(chat_id: message.chat.id, text: 'WAT?')
    end
  end

  def run
    @bot.listen do |message|
      reply(message)
    end
  end
end
