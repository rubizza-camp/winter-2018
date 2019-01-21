$LOAD_PATH << '.'
require 'rubyfish'
require 'translit'
require 'strings_distance_counter'
# Fills database hash with wordplays
class Rhymer
  include StringsDistanceCounter

  def initialize(songs_hash)
    @wordplays = {}
    songs_hash.each_entry do |key, song_lines|
      @wordplays[key] = []
      song_lines.each_slice(4) do |a, b, c, d|
        @wordplays[key] << [a, b, c, d].join("\n") if
            quadruple_wordplay?(a, b, c, d)
      end
    end
    @wordplays = @wordplays.compact
  end

  attr_accessor :wordplays
end
