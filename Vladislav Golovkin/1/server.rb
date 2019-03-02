require_relative 'bot_server'
require_relative 'data_manager'

trap 'SIGINT' do
  puts 'Exiting'
  exit 0
end

data_manager = DataManager.new
data_manager.collect_data
server = BotServer.new(data_manager)
server.run
