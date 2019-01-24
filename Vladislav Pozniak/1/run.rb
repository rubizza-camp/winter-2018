# frozen_string_literal: true

require_relative 'bot.rb'
require_relative 'db.rb'

# Parsing of arguments and doing the job
class Runner
  def initialize(arg)
    @arg = arg
    @db = Db.new
    check_requirements
    start(@arg)
  end

  def check_requirements
    puts 'Checking requirements...'
    check_db
    check_token
    puts 'All checks passed, go on!'
  end

  def clean_run
    @db.flush unless @db.empty?
    @db.fill
    Bot.new(@db)
  end

  def run
    if @db.empty?
      puts 'Seems like DB is empty. Will try to fill it.'
      @db.fill
    end
    Bot.new(@db)
  end

  def check_db
    puts 'Redis connection OK' if @db.up?
  rescue StandardError
    abort('Seems like Redis is not started')
  end

  def check_token
    abort('Seems like token file does not exist') unless File.file?('bot.token')
    abort('Seems like token file is empty') if File.empty?('bot.token')
    puts 'API Token OK'
  end

  def start(arg)
    case arg
    when 'clean_run'
      clean_run
    when 'run'
      run
    else
      puts 'Usage: ruby run.rb [run, clean_run]'
    end
  end
end

Runner.new(ARGV[0].to_s)
