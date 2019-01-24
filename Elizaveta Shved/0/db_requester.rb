require 'rubygems'
require 'sqlite3'

class DbRequester
  FILE_NAME = 'site_parsing_data.db'.freeze
  def initialize(product_name)
    @product_name = product_name
    @db = SQLite3::Database.open FILE_NAME
  end

  def request
    if check_record
      last_time
      lowest_cost_item
      maximim_cost_item
      similar_price
    else
      puts "#{@product_name} can not be found in database."
    end
  rescue SQLite3::Exception => e
    puts 'Exception occurred'
    puts e
  ensure
    @db&.close
  end

  private

  def lowest_cost_item
    str = @product_name.downcase
    response = @db.execute "SELECT * FROM Items WHERE Name LIKE '#{str} %' ORDER BY Price ASC LIMIT(1)"
    record = response.last
    date = revert_unix_date(record.last)
    cost = record[COST_INDEX]
    region = record[REGION_INDEX]
    puts "Lowest was on #{date.year}/#{date.month} at price #{cost} BYN in #{region}"
  end

  def maximim_cost_item
    str = @product_name.downcase
    response = @db.execute "SELECT * FROM Items WHERE Name LIKE '#{str} %' ORDER BY Price DESC LIMIT(1)"
    record = response.last
    date = revert_unix_date(record.last)
    cost = record[COST_INDEX]
    region = record[REGION_INDEX]
    puts "Maximum was on #{date.year}/#{date.month} at price #{cost} BYN in #{region}"
  end

  def similar_price
    response = @db.execute "SELECT DISTINCT Name FROM Items WHERE Price < '#{@last_time_cost + 0.5}' AND Price > '#{@last_time_cost - 0.5}' LIMIT(2)"
    puts "For similar price you also can afford #{response[1][0].capitalize} and #{response[0][0].capitalize}"
  end

  def check_record
    str = @product_name.downcase
    response = @db.execute "SELECT * FROM Items WHERE Name LIKE '#{str} %' ORDER BY Date DESC LIMIT(1)"
    response.first.nil? ? false : true
  end

  def last_time
    str = @product_name.downcase
    response = @db.execute "SELECT * FROM Items WHERE Name LIKE '#{str} %' ORDER BY Date DESC LIMIT(1)"
    @last_time_cost = response.last[COST_INDEX]
    region = response.last[REGION_INDEX]
    puts "'#{@product_name.capitalize}' is #{@last_time_cost} BYN in #{region} these days."
  end

  def revert_unix_date(unix_date)
    Time.at(unix_date)
  end
end
