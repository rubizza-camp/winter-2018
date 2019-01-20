require 'telegram/bot'

token = '671502180:AAGTzsMZ3nzk_ZTPx0UqlG2m48JendDrGis'

def wordplay
  puts "Test"
end

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    case message.text
    when '/start'
      bot.api.send_message(chat_id: message.chat.id, text: "Sup?")
    when 'Hey bot!'
      bot.api.send_message(chat_id: message.chat.id, text: "Hey bro!")
    when '/wordplay'
      wordplay
    when '/end'
      bot.api.send_message(chat_id: message.chat.id, text: "Cya, bro!") && return
    end
  end
end
