require 'rubygems'
require 'roo'
require 'roo-xls'
require 'csv'

module BelStat
  class Converter
    def convert_data(input_folder, output_folder)
      Dir["./#{input_folder}/*"].each do |raw_file|
        csv_file = "./#{output_folder}/" + raw_file.split('/')[-1].split('.x')[0] + '.csv'
        convert_excel2csv(raw_file, csv_file)
      end
    end

    private

    def convert_excel2csv(excel_file, csv_file)
      begin
        excel = create_excel(excel_file) 

        output = File.open(csv_file, 'w')
        7.upto(excel.last_row) do |line|
          output.write CSV.generate_line excel.row(line)
        end
      rescue StandardError => exception
        puts exception.message
      end
    end

    def create_excel(excel_file)
      if /xlsx$/.match?(excel_file)
        Roo::Excelx.new(excel_file)
      else
        Roo::Excel.new(excel_file)
      end
    end
  end
end

