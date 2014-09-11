require 'dotenv'
require 'csv'
require 'harvested'

module Timesheet
  class Importer
    Dotenv.load

    attr_reader :import_data

    def initialize(file_path)
      @import_data = ImportData.new(file_path)
    end

    def import!
      import_data.csv_data
    end

    def client
      Harvest.hardy_client(subdomain: ENV['HARVEST_SUBDOMAIN'], 
                           username: ENV['HARVEST_USERNAME'], 
                           password: ENV['HARVEST_PASSWORD'])
    end
  end

  class ImportData
    def initialize(file_path)
      @file_path = file_path
    end

    def csv_data
      csv_data = csv_rows.map{ |row| Hash[csv_headers.zip(row)] }
      csv_data.delete(csv_data.first)
      csv_data
    end

    def csv_headers
      @csv_headers = csv_rows.first.map{ |header| header.downcase.gsub(/\s/, '_').to_sym}
    end

    def csv_rows
      CSV.open(@file_path, "rb").read()
    end

    def time_entry(data_entry)
      Harvest::TimeEntry.new(data)
    end
  end
end
