require 'rubygems'
require 'time'
require 'open-uri'
require 'nokogiri'

class JobCentral
  BASE_URI = "http://xmlfeed.jobcentral.com"
  
  class Employer < Struct.new(:name, :file_uri, :file_size, :date_updated, :jobs)
    def self.all
      @employers = []
      ((html/"table")[-1]/"tr").each_with_index do |element, idx|
        next unless idx >= 2
        attributes = element/"td"
        
        employer = Employer.new
        employer.name = attributes[0].text
        employer.file_uri = BASE_URI + (attributes[1]/"a").attr('href')
        employer.file_size = attributes[2].text
        employer.date_updated = Time.parse attributes[3].text

        @employers << employer
      end
      @employers
    end

    def self.read(uri = BASE_URI + "/index.asp")
      open(uri).read
    end

    def self.html
      Nokogiri::HTML read
    end
    
    def read_jobs
      read file_uri
    end

    def xml
      Nokogiri::XML read_jobs
    end
    
    def jobs
      @jobs = []
      
      (xml/"job").each do |element|
        job = Job.new
        job.guid = element.at("guid").text
        job.title = element.at("title").text
        job.description = element.at("description").text
        job.link = element.at("link").text
        job.imagelink = element.at("imagelink").text
        job.expiration_date = Date.parse(element.at("expiration_date").text)
        job.employer_name = element.at("employer").text
        job.location = element.at("location").text
        element.css("industry").each do |industry|
          job.industries << industry.text
        end
        @jobs << job
      end

      @jobs
    end
  end

  class Job < Struct.new(:guid, :title, :description, :link, :imagelink, :industries, :expiration_date, :employer_name, :location)
    def industries
      @industries ||= []
    end
  end
end
