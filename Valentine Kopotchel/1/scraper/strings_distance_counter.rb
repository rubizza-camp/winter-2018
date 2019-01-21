require 'rubyfish'
require 'translit'
# Uses double metaphone to look for the words that sound identically
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

  def quadruple_wordplay?(word_a, word_b, word_c, word_d)
    temp = [word_a, word_b, word_c, word_d].compact
    return true if [word_a, word_b, word_c, word_d]
                   .join.include?('(') # usually contain different pronunciation

    temp = temp.map { |str| single_line_process(str) }
    temp.each { |arr| return true if arr.length != arr.uniq.length }
    temp.combination(2) do |arr_i, arr_j|
      return true if prod_not_unique?(arr_i, arr_j)
    end
    false
  end

  def prod_not_unique?(first, second)
    prod = first.product(second)
    return true if prod.length != prod.uniq.length

    false
  end
end
