$LOAD_PATH << '.'
require 'url_generator.rb'
require 'rubygems'
require 'nokogiri'
require 'json'
require 'net/http'
module ScraperHashGenerator
  include URLGenerator

  def songs_link_gen(ids)
    hash = {}
    ids.each do |id|
      league_url = gen_artist_url(id)
      hash[id] = JSON.parse(Net::HTTP.get_response(league_url).body)
    end
    hash
  end

  def process_song_link(url)
    doc = Nokogiri::HTML(Net::HTTP.get_response(url).body)
    doc.xpath('//script').remove
    lyrics = doc.css('div.lyrics')
    lyrics.text.split("\n").map(&:strip)
          .reject { |s| s.empty? || s.start_with?('(', '[') }
  end

  def lyrics_hash_gen(songs_hash)
    lyrics = {}
    songs_hash.each_value do |hash|
      hash = hash['response']['songs']
      hash.each do |elem|
        url = gen_song_url(elem['path'])
        title = elem['title']
        lyrics[title] = process_song_link(url)
      end
    end
    lyrics
  end
end