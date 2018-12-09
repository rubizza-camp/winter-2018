require 'rubygems'
require 'sqlite3'
require 'pry'
require './data_parser.rb'
require './download_sheets.rb'
require './db_requester.rb'


class Waiter
  def check_files
    binding.pry
    FileUtils.mkdir_p './data'
    Dir["./data/*.*"].count < 100 ? DownloadSheets.new.perform_data : true
  end

  def check_data
    File.new('test.db', 'a')
    @db = SQLite3::Database.open 'test.db'
    @db.execute "CREATE TABLE IF NOT EXISTS Items(Id INTEGER PRIMARY KEY AUTOINCREMENT, 
      Name Text, Region TEXT, Price REAL, Date INTEGER )"
    count = @db.execute "SELECT count(*) FROM Items"
    count[0][0].positive? ? true : DataParser.new.perform_data
  end

  def looping
    check_files
    check_data
    loop do
      puts 'What price are you looking for?'
      DbRequester.new(gets.chomp).request
    end
  end
end
Waiter.new.looping

