module BelStat
  class Viewer
    class << Viewer
        def show_info(query, stat, similars)
          puts  <<~MESS 
                --------------------------------------------------
                #{query.capitalize} is #{stat[:curr]} BYN in Minsk these days
                Lowest was on #{stat[:min_date]} at price #{stat[:min]} BYN
                Maximum was on #{stat[:max_date]} at #{stat[:max]} BYN
                --------------------------------------------------
          MESS
        end

        def show_similars(similars)
          similars.each { |str| str.gsub!(',','')}
          puts similars.join(', ').squeeze(" ").downcase
        end
    end
  end
end
