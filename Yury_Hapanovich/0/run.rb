require './get_data.rb'
require './price_searcher'

PATH_FOR_DATA = './data'.freeze

def user_input_check
  %w[y Y д Д].include?(gets.chomp)
end

until Dir.exist?(PATH_FOR_DATA) && !Dir['./data/*'].empty?
  puts 'You need to download data files'
  puts 'Do you want to download them? (y/n)'
  DataParser.download_data if user_input_check
end

answer = true
while answer
  PriceSearcher.new.analyze
  puts 'Do you want to look for something else? (y/n)'
  answer = user_input_check
end
