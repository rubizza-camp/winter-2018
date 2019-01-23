require 'open-uri'
require 'nokogiri'
require_relative 'db_wrapper'
class Parser
  def parse(url)
    page = Nokogiri::HTML(URI.parse(url).open)
    raw_wordplays = page.xpath('//p').map(&:text)

    clean(raw_wordplays)
  end

  private

  def clean(raw_list)
    wordplays = raw_list.select { |phrase| phrase.match?(/^\d+\./) }
    regex = /\.\s([^~]+)/
    wordplays.map { |wordplay| wordplay[regex, 1].strip }
  end
end
