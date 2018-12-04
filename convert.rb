require './lib/price_parser'
module BelStat
  class Converter
    def convert(input_folder, output_folder)
      Dir["./#{input_folder}/*"].each do |raw_file|
        csv_file = "./#{output_folder}/" + raw_file.split('/')[-1].split('.x')[0] + '.csv'
        convert_excel2csv(raw_file, csv_file)
      end
    end
  end
end
