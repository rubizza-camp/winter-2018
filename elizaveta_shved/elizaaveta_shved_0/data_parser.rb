require 'rubygems'
require 'roo'
require 'roo-xls'
require 'sqlite3'
require 'logger'

COST_INDEX = 3
REGION_INDEX = 2
DATE_FOR_DENOMIZATION = 1482181200
AMOUNT_FOR_DENOMOZATION = 10000.0

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
      check_data = (row[0].is_a?(String) && row[6].is_a?(Numeric) && row[8].is_a?(Numeric)) &&
       (row[12].is_a?(Numeric) && row[14].is_a?(Numeric) && row[16].is_a?(Numeric) && row[18].is_a?(Numeric))
    next unless check_data
      product_name = row[0].downcase
      brest_region = row[6]
      vitebsk_region = row[8]
      homel_region = row[10]
      grodno_region = row[12]
      minsk = row[14]
      minsk_region = row[16]
      mogilev_region = row[18]
      
      if date < DATE_FOR_DENOMIZATION
        brest_region = brest_region / AMOUNT_FOR_DENOMOZATION if !brest_region.nil?
        vitebsk_region = vitebsk_region / AMOUNT_FOR_DENOMOZATION if !vitebsk_region.nil?
        homel_region = homel_region / AMOUNT_FOR_DENOMOZATION if !homel_region.nil?
        grodno_region = grodno_region / AMOUNT_FOR_DENOMOZATION if !grodno_region.nil?
        minsk = minsk / AMOUNT_FOR_DENOMOZATION if !minsk.nil?
        minsk_region = minsk_region / AMOUNT_FOR_DENOMOZATION if !minsk_region.nil?
        mogilev_region = mogilev_region / AMOUNT_FOR_DENOMOZATION if !mogilev_region.nil?
      end

      @db.execute "INSERT INTO Items (name, region, price, date) VALUES('#{product_name}','Брестская область',#{brest_region}, #{date})"
      @db.execute "INSERT INTO Items (name, region, price, date) VALUES('#{product_name}','Витебская область',#{vitebsk_region}, #{date})"
      @db.execute "INSERT INTO Items (name, region, price, date) VALUES('#{product_name}','Гомельская область',#{homel_region}, #{date})"
      @db.execute "INSERT INTO Items (name, region, price, date) VALUES('#{product_name}','Гродненская область',#{grodno_region}, #{date})"
      @db.execute "INSERT INTO Items (name, region, price, date) VALUES('#{product_name}','Минск',#{minsk}, #{date})"
      @db.execute "INSERT INTO Items (name, region, price, date) VALUES('#{product_name}','Минская область',#{minsk_region}, #{date})"
      @db.execute "INSERT INTO Items (name, region, price, date) VALUES('#{product_name}','Могилевская область',#{mogilev_region}, #{date})"
    end
  end
  
  def convert_to_unix_date(path)
    date_keys = File.basename(path, ".*").split('_')
    month = date_keys[0].to_i
    year = date_keys[1].to_i
    Date.new(year, month, 1).to_time.to_i
  end
  
  def perform_data
    begin
      File.new('test.db', 'a')
      @db = SQLite3::Database.open 'test.db'
      @db.execute 'CREATE TABLE IF NOT EXISTS Items(Id INTEGER PRIMARY KEY AUTOINCREMENT, 
        Name Text, Region TEXT, Price REAL, Date INTEGER )'
      perform_files
    rescue SQLite3::Exception => e 
      puts 'Exception occurred'
      puts e
    ensure
      @db.close if @db
    end
  end 

  def logger
    @logger ||= Logger.new('data_parser.log')
  end
end
