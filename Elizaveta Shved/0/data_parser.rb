require 'rubygems'
require 'roo'
require 'roo-xls'
require 'sqlite3'
require 'logger'

COST_INDEX = 3
REGION_INDEX = 2
DATE_FOR_DENOMIZATION = 148_218_120_0
AMOUNT_FOR_DENOMIZATION = 10_000.0
REGIONS = [{ region_name: 'Брестская область', row_number: 6 },
           { region_name: 'Витебская область', row_number: 8 },
           { region_name: 'Гомельская область', row_number: 10 },
           { region_name: 'Гродненская область', row_number: 12 },
           { region_name: 'Минск', row_number: 14 },
           { region_name: 'Минская область', row_number: 16 },
           { region_name: 'Могилевская область', row_number: 18 }].freeze

ROW_DATA_TYPES = { '0': String, '6': Numeric, '8': Numeric, '10': Numeric,
                   '12': Numeric, '14': Numeric, '16': Numeric, '18': Numeric }.freeze

class DataParser
  def perform_files
    xls_files = Dir['./data/*.xls']
    xlsx_files = Dir['./data/*.xlsx']
    puts 'Perform data:'
    xlsx_files.each do |path|
      print '.'
      date = convert_to_unix_date(path)
      table = Roo::Spreadsheet.open(path)
      perform_rows(table, date)
    rescue Zip::Error => e
      logger.warn "Problem with parser, error: #{e}, file - #{path} "
    end

    xls_files.each do |path|
      print '.'
      date = convert_to_unix_date(path)
      table = Roo::Excel.new(path)
      perform_rows(table, date)
    rescue Zip::Error => e
      logger.warn "Problem with parser, error: #{e}, file - #{path} "
    rescue SQLite3::SQLException => e
      logger.warn "Problem with parser, error: #{e}, file - #{path} "
    rescue Ole::Storage::FormatError => e
      logger.warn "Problem with parser, error: #{e}, file - #{path} "
    end
  end

  def perform_rows(table, date)
    (9..table.last_row).each do |number|
      row = table.row(number)
      check_data = validate_row_data(row)
      next unless check_data

      product_name = row[0].downcase
      regions_cost = REGIONS.map { |region| row[region[:row_number]] }

      if date < DATE_FOR_DENOMIZATION
        regions_cost = regions_cost.map { |region_cost| region_cost / AMOUNT_FOR_DENOMIZATION unless region_cost.nil? }
      end

      REGIONS.each_with_index do |elem, index|
        @db.execute "INSERT INTO Items (name, region, price, date) VALUES('#{product_name}','#{elem[:region_name]}','#{regions_cost[index]}', '#{date}')"
      end
    end
  end

  def perform_data
    FileUtils.touch 'site_parsing_data.db'
    @db = SQLite3::Database.open 'site_parsing_data.db'
    @db.execute 'CREATE TABLE IF NOT EXISTS Items(Id INTEGER PRIMARY KEY AUTOINCREMENT,
      Name Text, Region TEXT, Price REAL, Date INTEGER )'
    perform_files
  rescue SQLite3::Exception => e
    puts 'Exception occurred'
    puts e
  ensure
    @db&.close
  end

  def convert_to_unix_date(path)
    date_keys = File.basename(path, '.*').split('_')
    month = date_keys[0].to_i
    year = date_keys[1].to_i
    Date.new(year, month, 1).to_time.to_i
  end

  def logger
    @logger ||= Logger.new('data_parser.log')
  end
end

private

def validate_row_data(row)
  ROW_DATA_TYPES.each do |key, data_type|
    return false unless row[key.to_s.to_i].is_a?(data_type)
  end
end
