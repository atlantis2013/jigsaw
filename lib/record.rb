## Copyright (C) 2013 Royce Davis (@r3dy__)
### #
### #This program is free software: you can redistribute it and/or modify
### #it under the terms of the GNU General Public License as published by
### #the Free Software Foundation, either version 3 of the License, or
### #any later version.
### #
### #This program is distributed in the hope that it will be useful,
### #but WITHOUT ANY WARRANTY; without even the implied warranty of
### #MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
### #GNU General Public License for more details.
### #
### #You should have received a copy of the GNU General Public License
### #along with this program. If not, see <http://www.gnu.org/licenses/>

require 'csv'

class Record
  # This class will define all attributes of an individual record.  For example fname, lname, email...
  # It should also have some class methods that can check if a record exists so as not to duplicate or print all records to the screen/report
  @@domain = ''
  @@domain_is_set = false
  @@total = 0
  @@records = Array.new 
  @@percent_complete = 0.0

  attr_accessor :fname, :lname, :fullname, :company, :position, :city, :state, :email1, :email2, :email3, :email4, :department, :username1, :username2, :username3, :username4

  def self.domain_is_set
    return @@domain_is_set
  end

  def self.set_domain(domain)
    @@domain = domain
    @@domain_is_set = true
  end

  def self.get_domain
    return @@domain
  end

  def self.counter(num)
    @@counter = num
  end

  def self.total
    return @@total
  end

  def self.set_percent_complete(percent)
    @@percent_complete = percent
  end

  def self.get_percent_complete
    return @@percent_complete
  end

  def initialize(record, domain)
    begin
      #loggedInClean = record_unclean.sub(/<a title(.*?)<\/a>/, "")	# added to clean the record when logged in, links are added to some contacts for points
      #tempArray = loggedInClean.split("=")	# modified
      self.lname = record['lastname']
      self.fname = record['firstname']
      self.fullname = self.fname + ' ' + self.lname
      self.position = record['title']
      self.email1 = self.fname.downcase + '.' + self.lname.downcase + '@' + domain
      self.email2 = self.fname.split(//)[0].to_s.downcase + self.lname.downcase + '@' + domain
      self.email3 = self.fname.downcase + self.lname.split(//)[0].to_s.downcase + '@' + domain
      self.email4 = self.lname.downcase + self.fname.split(//)[0].to_s.downcase + '@' + domain
      self.state = record['state']
      self.city =  record['city']
      self.company = record['company']
      #self.username1 = self.fname.downcase + "." + self.lname.downcase		# added
      #self.username2 = self.fname.split(//)[0].to_s.downcase + self.lname.downcase	# added
      #self.username3 = self.fname.downcase + self.lname.split(//)[0].to_s.downcase	# added
      #self.username4 = self.lname.downcase + self.fname.split(//)[0].to_s.downcase	# added
      unless Record.record_exists(self)
        @@records << self
        @@total += 1
      end
    rescue StandardError => create_record_error
      puts "Couldn't create a new record. #{create_record_error}"
      return create_record_error
    end

  end

  def self.record_exists(record)
    @@records.each do |rec|
      if rec.fullname == record.fullname && rec.position == record.position
        return true
      end
    end
    return false
  end 

  def self.write_all_records_to_report(reportname)
    puts "Generating the final #{reportname}.csv report"
    begin
      # Try and print all records to the report .csv file
      filename = "#{reportname}.csv"
      CSV.open(filename, 'w+') do |csv|
        csv << ['Full Name', 'Position', 'Email1', 'Email2', 'Email3', 'Email4', 'City', 'State']
        @@records.each do |record|
          csv << [record.fullname, record.position, record.email2, record.email1, record.email3, record.email4, record.city, record.state]
        end
        puts "Wrote #{@@records.length} records to #{filename}\r\n"
      end
    rescue StandardError => gen_report_error
      puts 'Error generating the report.'
      return gen_report_error
    end
  end

  def self.print_all_records_to_screen
    @@records.each do |record|
      puts record.fullname + "\t" + record.position + "\t" + record.email2 + "\t" + record.email1 + "\t" + record.city + "\t" + record.state
    end
    puts "Dumped #{@@records.length} records"
  end
end
