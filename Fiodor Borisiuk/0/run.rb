require 'roo'
require 'roo-xls'
require 'open-uri'
require 'nokogiri'
require 'net/http'

puts 'Please wait until the data is loaded.'

url = 'http://www.belstat.gov.by/ofitsialnaya-statistika/makroekonomika-i-okruzhayushchaya-sreda/tseny/operativnaya-informatsiya_4/srednie-tseny-na-potrebitelskie-tovary-i-uslugi-po-respublike-belarus'
html = URI.parse(url).open.read

doc = Nokogiri::HTML(html).to_s
ind_low = doc.index('СРЕДНИЕ ЦЕНЫ НА ТОВАРЫ, РЕАЛИЗУЕМЫЕ В РОЗНИЧНОЙ СЕТИ')
ind_high_def = doc.index('Средние цены (тарифы) на отдельные виды платных')
doc = doc[ind_low..ind_high_def]

months = %w[янв фев мар апр май июн июл авг сен окт ноя дек]
url_table = {}
f = true
while f
  ind_low = doc.index('<a href="')
  ind_high = doc.index('</a>')
  if ind_low && ind_high
    str = doc[ind_low..ind_high]
    ind = str.index('за')
    break if ind.nil?

    month = months.index(str[ind + 3..ind + 5]) + 1

    ind = str.index('200')
    ind = str.index('201') if ind.nil?
    break if ind.nil?

    year = str[ind..ind + 3]
    date = if month < 10
             '0'
           else
             ''
           end
    date += month.to_s + '-' + year
    url = str[str.index('"') + 1..str.index('>') - 2]
    url_table[date] = url
    doc = doc[ind_high + 2..ind_high_def]
  else
    f = false
  end
end

url_table.keys.each do |key|
  Net::HTTP.start('www.belstat.gov.by') do |http|
    resp = http.get(url_table[key])
    xls_format = if url_table[key].index('xlsx').nil?
                   'xls'
                 else
                   'xlsx'
                 end
    open("ex#{key}.#{xls_format}", 'wb') { |file| file.write(resp.body) }
  end
end

file_list = Dir.entries('.')
xls_list = []
file_list.each_with_object(xls_list) do |file, arr|
  arr.append(file) if file.index('xls')
end

xls_table = []
xls_list.each do |xls|
  ind = xls.index('20')
  xls_table.append([xls, xls[ind - 3..ind + 3]])
end

@table = {}

def find_frow(sheet)
  sheet.first_row.upto(sheet.last_row) do |i|
    # f = false
    sheet.first_column.upto(sheet.last_column) do |j|
      next if sheet.cell(i, j).to_s.index('ПРОДОВОЛЬСТВЕННЫЕ ТОВАРЫ').nil?

      @frow = i + 1
      return @frow
    end
  end
  @frow
end

xls_table.each do |xls|
  name, date = xls

  sheet = Roo::Spreadsheet.open(name).sheet(0)

  @frow = find_frow(sheet)

  price_arr = []
  @frow.upto(sheet.last_row) do |i|
    cur_price = []
    1.upto(sheet.last_column) do |j|
      cur_cell = sheet.cell(i, j).to_s
      next if cur_cell.nil?

      cur_cell = (cur_cell.to_f / 10_000).to_s\
        if cur_cell.to_f != 0.0 && date[5..6].to_f <= 16

      if cur_cell.length && cur_cell.index('.')
        cur_cell = cur_cell[0..cur_cell.index('.') + 2]\
          if cur_cell.length - cur_cell.index('.') >= 2
      end
      cur_price.append(cur_cell) if cur_cell
    end
    if cur_price[-1].to_s == cur_price[-1].to_f.to_s
      cur_price[0] = cur_price[0].downcase.capitalize
      price_arr.append(cur_price)
    end
  end
  @table[date] = price_arr
end

def find_by_kwd(arr, kwd)
  ans = []
  arr.each do |i|
    ans.append([i[0], i[-3]]) if i[0].to_s.index(kwd)
  end
  ans
end

def find_similar(arr, name, price)
  eps = 0.05
  ans = []
  arr.each do |line|
    next if line[0] == name

    if ((price - eps)..(price + eps)).cover?(line[-3].to_f)
      ans.append("'" + line[0] + "'")
    end
  end
  ans
end

def m_atoi(arr)
  return 0 if arr == []

  ans = arr[0]
  1.upto(arr.length - 2) do |i|
    ans += ', ' + arr[i]
  end
  ans += ' and ' + arr[-1] if arr[-1] != arr[0]
  ans + '.'
end

def parse_date(dat)
  dat[3..6] + '/' + dat[0..1]
end

puts "Done.\n\nEnter the query:"

today = '10-2018'
query = ''
while query != '^C'
  query = gets.chomp
  if query == ''
    query = 'Хлеб'
    puts "Sample for '#{query}':"
  end
  query = query.downcase.capitalize
  info = find_by_kwd(@table[today], query)

  puts "'#{query}' can not be found in database." if info == []

  info.each do |i|
    puts "'#{i[0]}' is #{i[1]} BYN in Minsk these days."

    kwd = i[0]
    min = i[1].to_f
    min_d = today
    max = i[1].to_f
    max_d = today
    @table.keys.each do |key|
      arr = @table[key]
      res = find_by_kwd(arr, kwd)[0]
      next if res.nil?

      price = res[1].to_f
      if price < min
        min = price
        min_d = key
      end
      if price > max
        max = price
        max_d = key
      end
    end

    puts "Lowest was on #{parse_date(min_d)} at price #{min} BYN"
    puts "Maximum was on #{parse_date(max_d)} at #{max} BYN"

    sim = m_atoi(find_similar(@table[today], i[0], i[1].to_f))

    puts "For similar price you also can afford #{sim}" if sim != 0

    puts "\n"
  end
  # break
end
