require 'rubygems'
require 'json'
require 'redis'
require 'telegram/bot'
redis = Redis.new(url: ENV['REDIS_URL'],
                  password: ENV['REDIS_PASSWORD']) # ENV was set in Heroku
h = redis.get('db')
h = JSON.parse h
titles = h.keys
Telegram::Bot::Client.run(ENV['TELEGRAM_TOKEN']) do |bot|
  bot.listen do |message|
    case message.text
    when '/start'
      hi = <<~HEREDOC
                Hello,#{message.from.first_name}.
        Use /wordplay to get a random wordplay.
      HEREDOC
      bot.api.send_message(chat_id: message.chat.id,
                           text: hi)
    when '/stop'
      bye = "Bye,#{message.from.first_name}"
      bot.api.send_message(chat_id: message.chat.id, text: bye)
    when '/wordplay'
      title = titles.sample
      lyrics = h[title].sample
      bot.api.send_message(chat_id: message.chat.id,
                           text: "#{title}\n#{lyrics}")
    end
  end
end
