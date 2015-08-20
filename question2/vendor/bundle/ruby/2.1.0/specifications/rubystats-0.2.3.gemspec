# -*- encoding: utf-8 -*-
# stub: rubystats 0.2.3 ruby lib

Gem::Specification.new do |s|
  s.name = "rubystats"
  s.version = "0.2.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Bryan Donovan - http://www.bryandonovan.com"]
  s.date = "2008-07-06"
  s.description = "Ruby Stats is a port of the statistics libraries from PHPMath. Probability distributions include binomial, beta, and normal distributions with PDF, CDF and inverse CDF as well as Fisher's Exact Test."
  s.email = "b.dondo+rubyforge@gmail.com"
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "README.txt"]
  s.files = ["History.txt", "Manifest.txt", "README.txt"]
  s.homepage = "http://rubyforge.org/projects/rubystats/"
  s.rdoc_options = ["--main", "README.txt"]
  s.rubyforge_project = "rubystats"
  s.rubygems_version = "2.4.8"
  s.summary = "Port of PHPMath to Ruby"

  s.installed_by_version = "2.4.8" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 2

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<hoe>, [">= 1.7.0"])
    else
      s.add_dependency(%q<hoe>, [">= 1.7.0"])
    end
  else
    s.add_dependency(%q<hoe>, [">= 1.7.0"])
  end
end
