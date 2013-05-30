# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{seer}
  s.version = "0.10.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Corey Ehmke / SEO Logic"]
  s.date = %q{2011-09-06}
  s.description = %q{ Seer is a lightweight, semantically rich wrapper for the Google Visualization API. It allows you to easily create a visualization of data in a variety of formats, including area charts, bar charts, column charts, gauges, line charts, and pie charts.}
  s.email = %q{corey@seologic.com}
  s.homepage = %q{http://github.com/Bantik/seer}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{Seer is a lightweight, semantically rich wrapper for the Google Visualization API.}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 1.2.9"])
    else
      s.add_dependency(%q<rspec>, [">= 1.2.9"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 1.2.9"])
  end
end
