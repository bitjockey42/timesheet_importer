require 'csv'
require 'harvested'

module Timesheet
  class Importer

    def initialize(file_path)
      @file_path = file_path
    end

    def import!
      csv_data.sort_by{ |data| data["Date"]}
    end

    protected
    
    def csv_data
      csv_data = csv_rows.map{ |row| Hash[csv_headers.zip(row)] }
      csv_data.delete(csv_data.first)
      csv_data
    end

    def csv_headers
      @csv_headers = csv_rows.first
    end

    def csv_rows
      CSV.open(@file_path, "rb").read()
    end

    def time_entry(data_entry)
      Harvest::TimeEntry.new(data)
    end
  end
end
