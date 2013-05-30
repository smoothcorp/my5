# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{googlecharts}
  s.version = "1.6.8"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Matt Aimonetti", "Andrey Deryabin"]
  s.date = %q{2011-05-20}
  s.description = %q{Generate charts using Google API & Ruby}
  s.email = %q{mattaimonetti@gmail.com deriabin@gmail.com}
  s.files = ["spec/fixtures/another_test_theme.yml", "spec/fixtures/test_theme.yml", "spec/gchart_spec.rb", "spec/spec_helper.rb", "spec/theme_spec.rb"]
  s.homepage = %q{http://googlecharts.rubyforge.org/}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{Generate charts using Google API & Ruby}
  s.test_files = ["spec/fixtures/another_test_theme.yml", "spec/fixtures/test_theme.yml", "spec/gchart_spec.rb", "spec/spec_helper.rb", "spec/theme_spec.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
