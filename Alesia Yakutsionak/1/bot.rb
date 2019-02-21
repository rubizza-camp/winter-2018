require 'telegram/bot'
require 'redis'
require 'yaml'

class Bot
  INVALID_COMMAND_TEXT = "I didn't understand you.".freeze
  SECRETS_PATH = 'secrets.yml'.freeze

  def initialize
    @redis = Redis.new
    @puns_count = @redis.keys('pun_*').count
  end

  def run
    Telegram::Bot::Client.run(load_token) do |bot|
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
      bot.api.sendMessage(chat_id: message.chat.id, text: wordplay_text)
    else
      bot.api.sendMessage(chat_id: message.chat.id, text: INVALID_COMMAND_TEXT)
    end
  end

  def wordplay_text
    random_pun = select_random_pun
    "Random wordplay [#{random_pun[:number]}]:\n#{random_pun[:text]}"
  end

  def select_random_pun
    i = rand(0..@puns_count - 1)
    { number: i, text: @redis.get("pun_#{i}") }
  end

  def load_token
    YAML.load_file(SECRETS_PATH)['TELEGRAM_TOKEN']
  end
end
