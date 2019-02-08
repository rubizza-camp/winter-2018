require 'rubygems'
require 'roo'
require 'roo-xls'
require 'csv'

module BelStat
  class Converter
    MONTH2DIGITAL = { 'январь' => '01', 'февраль' => '02', 'март' => '03',
                      'апрель' => '04', 'май' => '05', 'июнь' => '06',
                      'июль' => '07', 'август' => '08', 'сентябрь' => '09',
                      'октябрь' => '10', 'ноябрь' => '11', 'декабрь' => '12' }.freeze

    HEADERS_LINE = 6
    DATE_LINE = 3
    YEAR_NUM = 2
    MONTH_NUM = 1

    def convert_data(input_folder, output_folder)
      Dir["./#{input_folder}/*"].each do |raw_file|
        csv_file = "./#{output_folder}/" + File.basename(raw_file, '.*') + '.csv'
        convert_excel2csv(raw_file, csv_file)
      end
    rescue StandardError => exception
      puts exception.message
    end

    def rename2date(folder)
      Dir["./#{folder}/*"].each do |file|
        table = Roo::Spreadsheet.open(file)
        date = table.row(DATE_LINE).compact.first.squeeze(' ').split(' ')
        date = "#{MONTH2DIGITAL[date[MONTH_NUM]]}.#{date[YEAR_NUM]}"

        File.rename(file, gener_new_name(file, date))
      end
    end

    private

    def convert_excel2csv(excel_file, csv_file)
      excel = Roo::Spreadsheet.open(excel_file)

      CSV.open(csv_file, 'w') do |csv|
        excel.drop(HEADERS_LINE).each do |line|
          csv << line
        end
      end
      puts "#{excel_file} - successfully converted "
    end

    def gener_new_name(old_name, date)
      "#{File.dirname(old_name)}/#{date}.#{old_name.split('.').last}"
    end
  end
end
