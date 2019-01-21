require 'rubyfish'
require 'translit'
module StringsDistanceCounter
  def single_line_process(str)
    temp_arr = []
    str.split(' ').each do |word|
      temp_arr << RubyFish::DoubleMetaphone
                      .phonetic_code(Translit.convert(word, :english))
    end
    temp_arr = temp_arr.flatten.compact.reject { |s| s.length < 3 }
    temp_arr
  end

  def quadruple_wordplay?(a, b, c, d)
    temp = [a, b, c, d].compact
    return true if [a, b, c, d].join.include?('(') #usually contain different pronunciation such as 'а раб' - 'араб'

    temp = temp.map { |str| single_line_process(str) }
    temp.each { |arr| return true if arr.length != arr.uniq.length }
    temp.combination(2) do |arr_i, arr_j|
      return true if prod_not_unique?(arr_i, arr_j)
    end
    false
  end

  def prod_not_unique?(a, b)
    prod = a.product(b)
    return true if prod.length != prod.uniq.length

    false
  end

  /def closest_bruteforce(codes) #can be faster, but more code
    mindist = Float::MAX
    codes.combination(2) do |ci, cj|
      dist = RubyFish::Levenshtein.distance(ci, cj)
      mindist = dist if dist < mindist
    end
    mindist
  end/
end