# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{job_central}
  s.version = "1.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Michael Guterl"]
  s.date = %q{2009-05-27}
  s.email = %q{mguterl@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION.yml",
     "job_central.gemspec",
     "lib/job_central.rb",
     "spec/fixtures/employers.html",
     "spec/fixtures/jobs.xml",
     "spec/job_central_spec.rb",
     "spec/spec_helper.rb"
  ]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/mguterl/job_central}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.2}
  s.summary = %q{TODO}
  s.test_files = [
    "spec/job_central_spec.rb",
     "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<nokogiri>, ["~> 1.2.3"])
    else
      s.add_dependency(%q<nokogiri>, ["~> 1.2.3"])
    end
  else
    s.add_dependency(%q<nokogiri>, ["~> 1.2.3"])
  end
end