require 'csv'
require 'harvested'

module Timesheet
  class Importer

    def initialize(file_path)
      @file_path = file_path
    end

    def import!
      csv_data.each{ |d| puts d }
    end

    protected

    attr_reader :file_path, :csv_data
    
    def csv_data
      @csv_data = csv.map{ |row| Hash[csv.first.zip(row)] }
    end

    def csv
      CSV.open(file_path, "rb").read()
    end

    def time_entry(data_entry)
      Harvest::TimeEntry.new(data)
    end
  end
end
