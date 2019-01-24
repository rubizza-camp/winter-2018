require 'rubygems'
require 'json'
require 'redis'
require 'telegram/bot'
redis = Redis.new(url: ENV['REDIS_URL'],
                  password: ENV['REDIS_PASSWORD']) # ENV was set in Heroku
h = redis.get('db')
h = JSON.parse h.gsub('=>', ':')
Telegram::Bot::Client.run(ENV['TELEGRAM_TOKEN']) do |bot|
  bot.listen do |message|
    case message.text
    when '/start'
      bot.api.send_message(chat_id: message.chat.id, text: "Hello,
#{message.from.first_name}. Use /wordplay to get a random wordplay")
    when '/stop'
      bot.api.send_message(chat_id: message.chat.id, text: "Bye,
#{message.from.first_name}")
    when '/wordplay'
      title = h.keys.sample
      lyrics = h[title].sample
      bot.api.send_message(chat_id: message.chat.id,
                           text: "#{title} \n #{lyrics}")
    end
  end
end
