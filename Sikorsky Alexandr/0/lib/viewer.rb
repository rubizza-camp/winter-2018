module BelStat
  module Viewer
    def self.show_info(query, stat, similars)
      puts <<~MESS
        --------------------------------------------------
        #{query.capitalize} is #{stat[:curr]} BYN in Minsk these days
        Lowest was on #{stat[:min_date]} at price #{stat[:min]} BYN
        Maximum was on #{stat[:max_date]} at #{stat[:max]} BYN\n
        #{similars2string(similars)}
        --------------------------------------------------
      MESS
    end

    def self.similars2string(similars)
      message = 'For similar price you also can afford: '
      similars.map! do |str|
        str.delete!(',')
        str.downcase!.capitalize!
        '\'' + str + '\''
      end
      message + similars.join(' and ').squeeze(' ')
    end
  end
end
