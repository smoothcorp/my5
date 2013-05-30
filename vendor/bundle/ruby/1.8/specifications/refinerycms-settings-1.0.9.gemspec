# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{refinerycms-settings}
  s.version = "1.0.9"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Resolve Digital", "Philip Arndt", "David Jones", "Steven Heidel", "U\304\243is Ozols"]
  s.date = %q{2011-11-05}
  s.description = %q{The default settings engine that is required by Refinery CMS core. Adds programmer creatable, user editable settings for each engine.}
  s.email = %q{info@refinerycms.com}
  s.homepage = %q{http://refinerycms.com}
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{refinerycms}
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{Settings engine for Refinery CMS}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activerecord>, ["~> 3.0.10"])
      s.add_runtime_dependency(%q<refinerycms-base>, ["= 1.0.9"])
    else
      s.add_dependency(%q<activerecord>, ["~> 3.0.10"])
      s.add_dependency(%q<refinerycms-base>, ["= 1.0.9"])
    end
  else
    s.add_dependency(%q<activerecord>, ["~> 3.0.10"])
    s.add_dependency(%q<refinerycms-base>, ["= 1.0.9"])
  end
end
