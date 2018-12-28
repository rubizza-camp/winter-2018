require 'rake'
require 'roo'
require 'roo-xls'
MONTH = {
  'январь' => '01',
  'февраль' => '02',
  'март' => '03',
  'апрель' => '04',
  'май' => '05',
  'июнь' => '06',
  'июль' => '07',
  'август' => '08',
  'сентябрь' => '09',
  'октябрь' => '10',
  'ноябрь' => '11',
  'декабрь' => '12'
}.freeze

module TableConverter
  def self.denomination_convertation(table, price, const)
    date = get_month_and_year(table)
    price[const] =
      if date[1].to_i < 2017
        (price[const] / 10_000.0).round(2)
      else
        price[const].round(2)
      end
    price
  end

  def self.converting_similar_name(elem)
    elem.split(' ').select { |el| el =~ /^[[:upper:]]+/ }.join(' ').downcase
  end

  def self.get_month_and_year(filename)
    filename.row(3)[0].split(' ').select { |el| /20[01][0-9]$/.match?(el) || MONTH.key?(el) }
  end

  def self.convert_month_and_year(filename)
    date = get_month_and_year(filename)
    date[0] = MONTH[date[0]]
    date.reverse.join('/')
  end
end
