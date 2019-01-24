require 'rubygems'
require 'rubyfish'
require 'translit'
# Uses double metaphone to look for the words that sound identically
module StringsDistanceCounter
  def single_line_process(str)
    soundcodes = str.split(' ').map do |word|
      RubyFish::DoubleMetaphone.phonetic_code(Translit.convert(word, :english))
    end
    soundcodes = soundcodes.flatten.compact.reject { |s| s.length < 3 }
    soundcodes
  end

  def not_unique?(arr)
    arr.length != arr.uniq.length
  end

  def quadruple_wordplay?(*args)
    strings_buffer = args.compact
    # usually contain different pronunciation
    return true if strings_buffer.any? { |str| str.include?('(') }

    strings_buffer = strings_buffer.map { |str| single_line_process(str) }
    strings_buffer.each do |metaphone_codes|
      return true if not_unique?(metaphone_codes)
    end
    strings_buffer.combination(2) do |arr_i, arr_j|
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
