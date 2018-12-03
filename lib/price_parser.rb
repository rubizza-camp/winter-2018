require 'rubygems'
require 'roo'
require 'roo-xls'
require 'csv'

def convert_excel2csv(excel_file, csv_file)
  excel = if excel_file =~ /xlsx$/
            Roo::Excelx.new(excel_file)
          else
            Roo::Excel.new(excel_file)
          end

  output = File.open(csv_file, 'w')
  7.upto(excel.last_row) do |line|
    output.write CSV.generate_line excel.row(line)
  end
rescue StandardError => exception
  puts exception.message
end
