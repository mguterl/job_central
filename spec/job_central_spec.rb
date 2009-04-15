require File.dirname(__FILE__) + '/spec_helper'

__DIR__ = File.dirname(__FILE__)

FakeWeb.register_uri(:get, JobCentral::BASE_URI + "/index.asp",
                     :string => File.read(__DIR__ + "/fixtures/employers.html"))
FakeWeb.register_uri(:get, JobCentral::BASE_URI + "/feeds/1105media.xml",
                     :string => File.read(__DIR__ + "/fixtures/jobs.xml"))

describe JobCentral do
  before(:each) do
    @employers = JobCentral::Employer.all
  end
  
  it "should fetch the list of employers" do
    @employers.should respond_to(:each)
  end

  it "should parse the format from the feed" do
    JobCentral.parse_date("4/12/2009 5:59:01 AM").
      should == DateTime.new(2009, 4, 12, 5, 59, 1)
  end

  describe JobCentral::Employer do
    before(:each) do
      @media = @employers.first
    end
    
    it "should have attributes parsed from the html" do
      @media.should_not be_nil
      @media.name.should == "1105 Media, Inc."
      @media.file_uri.should == "#{JobCentral::BASE_URI}/feeds/1105media.xml"
      @media.file_size.should == "15 KB"
      @media.date_updated.should == DateTime.new(2009, 4, 12, 5, 59, 1)
      @media.jobs.should respond_to(:each)
    end

    it "should read the html from job central" do
      JobCentral::Employer.read.should == File.read(__DIR__ + "/fixtures/employers.html")
    end

    it "should read the xml feed of jobs" do
      @media.read_jobs.should == File.read(__DIR__ + "/fixtures/jobs.xml")
    end

    describe JobCentral::Job do
      before(:each) do
        @writer = @media.jobs.first
      end
      
      it "should have attributes parsed from the xml" do
        @writer.guid.should == "1105media-24064"
        @writer.title.should == "New Products Writer"
        @writer.description.should == JOB_DESCRIPTION # check eof
        @writer.link.should == "http://jcnlx.com/3eca112f27834df8b7dbd803d6ecf097105"
        @writer.imagelink.should == "http://images.jobcentral.com/companylogos/1105media.gif"
        @writer.industries.should == ["Media / Publishing"]
        @writer.expiration_date.should == Date.new(2009, 4, 16)
        @writer.employer_name.should == "1105 Media, Inc."
        @writer.location.should == "Dallas, TX, 75219, USA"
      end
    end
  end
end

BEGIN {
  JOB_DESCRIPTION = <<-EOF
Job Details
New Products Writer
Send Job to Friend &amp;#187;
Apply Now &amp;#187;
Location: Dallas, TX
Department: Editorial
Job Type: Hire
Openings: 0 open, out of 1 available

* 
1105 Media is looking for a detail-oriented New Products Writer in its Dallas, Texas office who can write and edit new products for several B2B magazines.
Position Profile:

As a New Products Writer, you will be responsible for writing 120 to 200 products per month. This requires excellent copyediting and organizational skills and the ability to describe the features and benefits of a product in 80 words or fewer. Occasionally you will be needed to proof articles and pages.

Responsibilities include:
* Writing 120 to 200 products per month.
* Copyediting stories and page proofs.
* Helping the editorial team post products to Web sites.
* Sending out monthly e-mail blasts for new products.
* Producing e-newsletters for magazines.

The ideal candidate for this position will possess the following qualifications:
* At least one year professional experience, preferably in communications or journalism.
* BA/BS in Journalism/English/Communications or related field of study.
Experience in the following areas will be considered a plus:
* HMTL coding
* B2B publishing
* Sitecore CMS
1105 Media is based in Chatsworth,CA, with primary offices throughtout the United States. The company was formed in April 2006 by Nautic Partners LLC, Alta Communications, and President/CEO Neal Vitale.
We offer a competitive salary and a comprehensive benefits package that includes medical/dental/vision insurance, life insurance, disability insurance, 401(k) plan, and a generous paid time off (PTO)/holiday plan.
We are an equal opportunity employer.
Send Job to Friend &amp;#187;
Apply Now &amp;#187;
EOF
}
