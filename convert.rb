require './lib/price_parser'

Dir['./raw_data/*'].each do |raw_file|
  csv_file = './csv_data/' + raw_file.split('/')[-1].split('.x')[0] + '.csv'
  convert_excel2csv(raw_file, csv_file)
end
