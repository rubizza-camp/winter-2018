require_relative 'base'
require 'telegram_bot'

token = '723564519:AAHV5KL3h0pM0WZEv6_tcb5_5nbRdnJ0ToY'

class WordplayBot
  # COMMANDS = [/hi/i, /wordplay/i]

  def initialize(token)
    @bot = TelegramBot.new(token: token)
    @db = DBWrapper.new
    # @commands_hash =
  end

  def start
    @bot.get_updates(fail_silently: true) do |message|
      # puts "@#{message.from.username}: #{message.text}"
      reply2message(message)
    end
  end

  def random_wordplay
    @db.random_record
  end

  def greet(name)
    "Hello, #{name}!"
  end

  def unknown_command(name, command)
    "#{name}, have no idea what #{command} means."
  end

  def reply2message(message)
    command = message.get_command_for(@bot)

    message.reply do |reply|
      reply.text = case command
                   when /hi/i
                     greet(message.from.first_name)
                   when /wordplay/i
                     random_wordplay
                   else
                     unknown_command(message.from.first_name, command.inspect)
                   end
      # puts "sending #{reply.text.inspect} to @#{message.from.username}"
      reply.send_with(@bot)
    end
  end

  def create_commands_hash; end
end
