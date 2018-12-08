require './get_data.rb'
require './price_searcher'

def answer_checker
  %w[y Y д Д].include?(gets.chomp)
end

puts 'Please, download data files if you run application first.'
puts 'Do you want to download data files? (y/n)'
download_data if answer_checker
loop do
  PriceSearcher.new.analyze
  puts 'Do you want to looking for something else? (y/n)'
  break unless answer_checker
end
