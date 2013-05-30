# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{decent_exposure}
  s.version = "1.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6") if s.respond_to? :required_rubygems_version=
  s.authors = ["Stephen Caudill", "Jon Larkowski"]
  s.date = %q{2011-02-27}
  s.description = %q{
    DecentExposure helps you program to an interface, rather than an
    implementation in your Rails controllers.  The fact of the matter is that
    sharing state via instance variables in controllers promotes close coupling
    with views.  DecentExposure gives you a declarative manner of exposing an
    interface to the state that controllers contain and thereby decreasing
    coupling and improving your testability and overall design.
  }
  s.email = %q{scaudill@gmail.com}
  s.homepage = %q{http://github.com/voxdolo/decent_exposure}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{A helper for creating declarative interfaces in controllers}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, ["~> 2.3.0"])
      s.add_development_dependency(%q<mocha>, ["~> 0.9.8"])
      s.add_development_dependency(%q<actionpack>, [">= 0"])
      s.add_development_dependency(%q<activesupport>, [">= 0"])
    else
      s.add_dependency(%q<rspec>, ["~> 2.3.0"])
      s.add_dependency(%q<mocha>, ["~> 0.9.8"])
      s.add_dependency(%q<actionpack>, [">= 0"])
      s.add_dependency(%q<activesupport>, [">= 0"])
    end
  else
    s.add_dependency(%q<rspec>, ["~> 2.3.0"])
    s.add_dependency(%q<mocha>, ["~> 0.9.8"])
    s.add_dependency(%q<actionpack>, [">= 0"])
    s.add_dependency(%q<activesupport>, [">= 0"])
  end
end
