# -*- encoding: utf-8 -*-
# stub: distribution 0.7.3 ruby lib

Gem::Specification.new do |s|
  s.name = "distribution"
  s.version = "0.7.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Claudio Bustos"]
  s.date = "2015-05-28"
  s.description = "Distribution"
  s.email = ["clbustos@gmail.com"]
  s.executables = ["distribution"]
  s.files = ["bin/distribution"]
  s.homepage = "https://github.com/sciruby/distribution"
  s.rubygems_version = "2.4.8"
  s.summary = "Distribution"

  s.installed_by_version = "2.4.8" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<rspec>, ["~> 3.2"])
    else
      s.add_dependency(%q<bundler>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<rspec>, ["~> 3.2"])
    end
  else
    s.add_dependency(%q<bundler>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rspec>, ["~> 3.2"])
  end
end
