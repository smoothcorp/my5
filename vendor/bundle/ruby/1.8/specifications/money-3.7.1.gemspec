# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{money}
  s.version = "3.7.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6") if s.respond_to? :required_rubygems_version=
  s.authors = ["Tobias Luetke", "Hongli Lai", "Jeremy McNevin", "Shane Emmons", "Simone Carletti", "Jean-Louis Giordano", "Joshua Clayton", "Bodaniel Jeanes", "Tobias Schmidt", "Chris Kampmeier", "Romain G\303\251rard", "Eloy", "Josh Delsman", "Pelle Braendgaard", "Tom Lianza", "James Cotterill", "Fran\303\247ois Beausoleil", "Abhay Kumar", "pconnor", "Christian Billen", "Ilia Lobsanov", "Andrew White"]
  s.date = %q{2011-06-14}
  s.description = %q{This library aids one in handling money and different currencies.}
  s.email = ["hongli@phusion.nl", "semmons99+RubyMoney@gmail.com"]
  s.homepage = %q{http://money.rubyforge.org}
  s.require_paths = ["lib"]
  s.requirements = ["json if you plan to import/export rates formatted as json"]
  s.rubyforge_project = %q{money}
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{Money and currency exchange support library.}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<i18n>, ["~> 0.4"])
      s.add_development_dependency(%q<rspec>, [">= 2.0.0"])
      s.add_development_dependency(%q<yard>, [">= 0"])
      s.add_development_dependency(%q<json>, [">= 0"])
    else
      s.add_dependency(%q<i18n>, ["~> 0.4"])
      s.add_dependency(%q<rspec>, [">= 2.0.0"])
      s.add_dependency(%q<yard>, [">= 0"])
      s.add_dependency(%q<json>, [">= 0"])
    end
  else
    s.add_dependency(%q<i18n>, ["~> 0.4"])
    s.add_dependency(%q<rspec>, [">= 2.0.0"])
    s.add_dependency(%q<yard>, [">= 0"])
    s.add_dependency(%q<json>, [">= 0"])
  end
end
