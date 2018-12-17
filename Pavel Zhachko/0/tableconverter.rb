require 'rake'
require 'roo'
require 'roo-xls'

module TableConverter
  def self.denomination_convertation(date, price, const)
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
end
