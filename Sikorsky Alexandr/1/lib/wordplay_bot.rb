require_relative 'db_wrapper'
require 'telegram_bot'

class WordplayBot
  def initialize(token)
    @bot = TelegramBot.new(token: token)
    @db = DBWrapper.new
    @commands = create_commands
  end

  def start
    @bot.get_updates(fail_silently: true) do |message|
      reply2message(message)
    end
  end

  private

  def reply2message(message)
    user_command = message.get_command_for(@bot)

    message.reply do |reply|
      required_command = @commands.find { |command| user_command.match?(command[:regex]) }

      reply.text = required_command ? required_command[:proc].call(message) : unknown_command(message)
      reply.send_with(@bot)
    end
  end

  def random_wordplay
    @db.random_record
  end

  def greeting(message)
    "Hello, #{message.from.first_name}!"
  end

  def unknown_command(message)
    "#{message.from.first_name}, have no idea what it means."
  end

  def create_commands
    [{ regex: /hi/i, proc: ->(*args) { greeting(args.first) } },
     { regex: /wordplay/i, proc: ->(*_args) { random_wordplay } }]
  end
end
