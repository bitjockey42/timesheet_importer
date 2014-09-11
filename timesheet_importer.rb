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
      import_data.csv_data.each do |entry|
        puts "Now importing for #{entry[:date]}: #{entry[:hours]} hours for #{entry[:task]} in #{entry[:project]}"
        submitted = client.time.create(time_entry(entry))
        puts "Imported #{submitted}"
      end
    end

    def time_entry(entry)
      Harvest::TimeEntry.new(notes: entry[:notes],
                             hours: entry[:hours].to_f,
                             spent_at: entry[:date],
                             project_id: projects[entry[:project]],
                             task_id: tasks[entry[:task]])
    end
    
    def tasks
      mapped_tasks = trackable_projects.map{ |project| project["tasks"]}.flatten.uniq
      @tasks ||= Hash[mapped_tasks.map{ |task| [task["name"],task["id"].to_i]}] 
    end

    def clients
      @clients ||= Hash[trackable_projects.map{ |project| [project["client"],project["client_id"].to_i] }]
    end

    def projects
      @projects ||= Hash[trackable_projects.map{ |project| [project["name"],project["id"].to_i] }]
    end

    def trackable_projects
      @trackable_projects ||= client.time.trackable_projects
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
