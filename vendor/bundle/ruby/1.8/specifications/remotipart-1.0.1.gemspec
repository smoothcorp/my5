# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{remotipart}
  s.version = "1.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Greg Leppert", "Steve Schwartz"]
  s.date = %q{2011-11-27 00:00:00.000000000Z}
  s.description = %q{Remotipart is a Ruby on Rails gem enabling remote multipart forms (AJAX style file uploads) with jQuery.
    This gem augments the native Rails 3 jQuery-UJS remote form function enabling asynchronous file uploads with little to no modification to your application.
    }
  s.email = ["greg@formasfunction.com", "steve@alfajango.com"]
  s.homepage = %q{http://www.alfajango.com/blog/remotipart-rails-gem/}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{Remotipart is a Ruby on Rails gem enabling remote multipart forms (AJAX style file uploads) with jQuery.}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<thoughtbot-shoulda>, [">= 0"])
    else
      s.add_dependency(%q<thoughtbot-shoulda>, [">= 0"])
    end
  else
    s.add_dependency(%q<thoughtbot-shoulda>, [">= 0"])
  end
end
