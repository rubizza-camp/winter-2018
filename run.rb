require_relative 'lib/price_parser'
require 'pry'

def find_price(file_path, product)
  CSV.open(file_path, headers: true) do |goods|
    goods.each do |good|
      if good[0] =~ /(.*)#{product}(.*)/i
        # binding.pry
        return good['Минская'].to_f
      end
    end
  end
  -1
end

def find_similar(file_path, from, to)
  similar_list = []
  CSV.open(file_path, headers: true) do |goods|
    goods.each do |good|
      price = good['Минская'].to_f
      next if price.zero?

      similar_list << good[0] if price >= from && price <= to
    end
  end
  similar_list
end

def grab_actual_date
  month = Time.now.month
  year = Time.now.year
  loop do # 0.upto(Dir['./csv_data/*'].length)
    curr_date = month.to_s + '.' + year.to_s
    return curr_date if File.file? "./csv_data/#{curr_date}.csv"

    month -= 1
    if month.zero?
      year -= 1
      month = 12
    end
  end
end

curr_date = grab_actual_date

loop do
  query = gets.chomp

  min = 0
  max = 0
  curr = 0
  min_date = max_date = '01.0000'

  # puts find_price path, query unless query.empty?
  Dir['./csv_data/*'].each do |path|
    price = find_price(path, query)
    next if price <= 0

    date = path.split('/')[-1].split('.c')[0]

    (curr = price) if date == curr_date

    (price /= 10_000) if price > 1000
    if price > max
      max = price
      max_date = date
    end

    if min.zero? || price < min
      min_date = date
      min = price
    end
  end

  similar_list = find_similar("./csv_data/#{curr_date}.csv", curr - 0.2, curr + 0.2)
  similar_list.join(',')
  puts '-------------'
  puts "curr - #{curr}|||min #{min} -- #{min_date} |||
   max -- #{max} #{max_date}} simmilar #{similar_list}"
end
