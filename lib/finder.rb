module BelStat
  class Finder
    attr_accessor :region
    def initialize(region)
      @region = region
    end

    def find_price(file_path, product_name)
      CSV.open(file_path, headers: true) do |products|
        products.each do |product|
          return product[@region].to_f if /(.*)#{product_name}(.*)/i.match?(product[0])
        end
      end
      -1
      end

    def find_similar(file_path, from, to)
      similar_list = []
      CSV.open(file_path, headers: true) do |products|
        products.each do |product|
          price = product[@region].to_f
          next if price.zero?

          similar_list << product[0] if price >= from && price <= to
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
  end
end
