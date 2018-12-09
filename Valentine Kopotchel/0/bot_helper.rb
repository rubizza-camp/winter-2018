# Doing some dirty work to make less code in BreadBot
module BotHelper
  PRICE_COLUMN_MINSK = 16
  NAME_COLUMN = 0

  def build_page(key)
    path = HASH_OF_TABLES[key]
    xlsx = Roo::Spreadsheet.open(path)
    xlsx.sheet 0
  end

  def deflation?(date)
    date[0, 4] < '2017'
  end

  def row_valid?(row)
    !row[NAME_COLUMN].to_s.empty? && row[PRICE_COLUMN_MINSK].is_a?(Numeric)
  end

  def build_hash(key)
    fin_hash = {}
    build_page(key).each do |row|
      next unless row_valid?(row)

      val = row[PRICE_COLUMN_MINSK]
      val /= 10_000.0 if deflation? key
      fin_hash[row[NAME_COLUMN]] = val
    end
    fin_hash
  end

  def make_normal(str)
    str.capitalize
  end

  def reg_build(str)
    str = str.strip
    r = str.upcase
    temp = Regexp.new("(#{r}$|#{r}\s|#{r},)")
    Regexp.and_union(/(^|[\P{L}])/, temp)
  end

  def split_key(str)
    [str[0, 4], str[-2, 2]]
  end

  def minmax_assign(hash)
    min = hash.keys.min
    max = hash.keys.max
    a = hash[min]
    b = hash[max]
    [min, max, a, b]
  end

  def write_minmax_info(hash)
    min, max, a, b = minmax_assign(hash)
    puts "Lowest was on #{(split_key a)[1]}/#{(split_key a)[0]} "\
"at #{min.round(2)} BYN"
    puts "Highest was on #{(split_key b)[1]}/#{(split_key b)[0]} "\
"at #{max.round(2)} BYN"
  end
end
