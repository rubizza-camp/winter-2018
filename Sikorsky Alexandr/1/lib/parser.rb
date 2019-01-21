require 'open-uri'
require 'nokogiri'
require 'pry-byebug'
require_relative 'db_wrapper'
class Parser
  REGEX = /\.\s([^~]+)/.freeze

  def parse(url)
    page = Nokogiri::HTML(URI.parse(url).open)
    raw_wordplays = page.xpath('//p').map(&:text)

    clean(raw_wordplays)
  end

  private

  def clean(raw_list)
    wordplays = raw_list.select { |phrase| phrase.match?(/^\d+\./) }

    wordplays.map { |wordplay| wordplay[REGEX, 1].strip }
  end
end

if $PROGRAM_NAME == __FILE__
  parser = Parser.new
  wordplays = BASE_PAGES.reduce([]) { |stach, url| stach << parser.parse(url) }

  db_wrapper = DBWrapper.new
  db_wrapper.flush
  db_wrapper.multiple_set(wordplays.flatten)
end
