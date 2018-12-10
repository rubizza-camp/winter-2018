require_relative 'lib/viewer'
require_relative 'lib/converter'
require_relative 'lib/downloader'
require_relative 'lib/finder'
require 'fileutils'

WORK_DIR = 'csv_data'.freeze
RAW_DIR = 'raw_data'.freeze

REGION = 'Минская'.freeze

if !Dir.exist?("./#{WORK_DIR}") || Dir.empty?("./#{WORK_DIR}")
  FileUtils.mkdir_p("./#{WORK_DIR}")
  FileUtils.mkdir_p("./#{RAW_DIR}")

  downloader = BelStat::Downloader.new
  downloader.download_excels RAW_DIR

  converter = BelStat::Converter.new
  puts 'renaming...'
  converter.rename2date RAW_DIR
  puts 'converting...'
  converter.convert_data RAW_DIR, WORK_DIR
  puts "READY\n\n"
end

loop do
  finder = BelStat::Finder.new(REGION, WORK_DIR)
  viewer = BelStat::Viewer

  puts 'What price are you looking for?'
  query = gets.chomp

  next if query.empty?

  stat = finder.find_stat query
  if !stat[:curr].nil?
    similars = finder.find_similar(stat[:curr] - 0.2, stat[:curr] + 0.2)
    similars.reject! { |prod| /.*#{query}.*/i.match?(prod) }
    viewer.show_info(query, stat, similars)
  else
    puts "Sorry, nothing was found for '#{query}'\n\n"
  end
end
