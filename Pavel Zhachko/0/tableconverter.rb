require 'rake'
require 'roo'
require 'roo-xls'

MINSK_CONSTATN_CELL_COL = 14

module TableConverter
  def self.denomination_convertation(date, price)
    price[MINSK_CONSTATN_CELL_COL] =
      if date[1].to_i < 2017
        (price[MINSK_CONSTATN_CELL_COL] / 10_000.0).round(2)
      else
        price[MINSK_CONSTATN_CELL_COL].round(2)
      end
    price
  end

  def self.converting_similar_name(elem)
    elem.split(' ').select { |el| el =~ /^[[:upper:]]+/ }.join(' ').downcase
  end
end
