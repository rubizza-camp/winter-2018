require 'telegram/bot'
require 'redis'

class Bot
  INVALID_COMMAND_TEXT = "I didn't understand you.".freeze
  BOT_TOKEN = 'Your_Telegram_Bot_Token'.freeze

  def initialize
    @redis = Redis.new
    @puns_count = @redis.keys('pun_*').count
  end

  def run
    Telegram::Bot::Client.run(BOT_TOKEN) do |bot|
      bot.listen do |message|
        reply(bot, message)
      end
    end
  end

  private

  def reply(bot, message)
    case message.text
    when /^hey|hi|hello$/i
      bot.api.sendMessage(chat_id: message.chat.id, text: "Hey, #{message.from.first_name}")
    when '/wordplay' then
      random_pun = select_random_pun
      wordplay_text = "Random wordplay [#{random_pun[:number]}]:\n#{random_pun[:text]}"
      bot.api.sendMessage(chat_id: message.chat.id, text: wordplay_text)
    else
      bot.api.sendMessage(chat_id: message.chat.id, text: INVALID_COMMAND_TEXT)
    end
  end

  def select_random_pun
    i = rand(0..@puns_count-1)
    { number: i, text: @redis.get("pun_#{i}") }
  end
end
