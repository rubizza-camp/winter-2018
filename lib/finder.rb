require 'csv'

module BelStat
  class Finder
    attr_accessor :region

    def initialize(region, work_directory)
      @region = region
      @work_directory = work_directory
      @actual_file = get_actual_file
      @actual_file_path = "./#{@work_directory}/#{@actual_file}"
      @curr_date = file_path2date @actual_file
    end

    def find_price(file_path, product_name)
      CSV.open(file_path, headers: true) do |products|
        products.each do |product|
          return product[@region].to_f if /(.*)#{product_name}(\s|\z)+(.*)/i.match?(product[0])
        end
      end
      nil
    end

    def find_similar(from, to, file_path = @actual_file_path)
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

    def find_stat query
      stat = {min: 0, max: 0, curr: 0, min_date: '', max_date: ''}

      Dir["./#{@work_directory}/*"].each do |path|
        price = find_price(path, query)
        next if price.nil?

        date = file_path2date path

        stat[:curr] = price if date == @curr_date

        price /= 10_000 if price > 1000

        if price > stat[:max]
          stat[:max], stat[:max_date] = price, date
        end

        if stat[:min].zero? || price < stat[:min]
          stat[:min], stat[:min_date] = price, date
        end
      end
      stat
    end
    
    private

    def file_path2date path
      path.split('/')[-1].split('.c')[0]
    end

    def get_actual_file
      month , year = Time.now.month, Time.now.year

      0.upto(Dir["./#{@work_directory}/*"].length) do
        curr_file = month.to_s + '.' + year.to_s + '.csv'
        return curr_file if File.file? "./#{@work_directory}/#{curr_file}"

        month -= 1
        if month.zero?
          year -= 1
          month = 12
        end
      end
    end
  end
end

if __FILE__==$0
  finder = BelStat::Finder.new 'Минская', 'csv_data'
  stat = finder.find_stat 'хлеб'
  puts stat
  puts finder.find_similar(stat[:curr] - 0.5, stat[:curr] + 0.5)
end