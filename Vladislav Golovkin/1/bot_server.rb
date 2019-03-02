require 'telegram_bot'

TELEGRAM_BOT_TOKEN = '719163829:AAHNfvBccKUQ3KUqk-qEGc2EdSBRixmtYh4'.freeze

# class for handling bot activity
class BotServer
  def initialize(manager)
    @data_manager = manager
    @bot = TelegramBot.new(token: TELEGRAM_BOT_TOKEN)
  end

  # reponse to user
  def process_response(message)
    command = message.get_command_for(@bot)
    message.reply do |reply|
      reply.text = get_output(message, command)
      puts "Server to user @#{message.from.username}: #{reply.text.inspect}"
      reply.send_with(@bot)
    end
  end

  # generate output string
  def get_output(message, command)
    case command
    when '/wordplay'
      @data_manager.random_rofl.to_s
    when '/start'
      'Hello, traveler! Use /wordplay to hear rofl!'
    else
      "#{message.from.first_name}, can you just use '/wordplay', I'm not so smart."
    end
  end

  # use this to run your bot
  def run
    puts 'Server is online'
    @bot.get_updates(fail_silently: true) do |message|
      puts "User @#{message.from.username}: #{message.text}"
      process_response(message)
    end
  end
end
