# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{acts_as_indexed}
  s.version = "0.7.7"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Douglas F Shearer"]
  s.date = %q{2011-11-14}
  s.description = %q{Acts As Indexed is a plugin which provides a pain-free way to add fulltext search to your Ruby on Rails app}
  s.email = %q{dougal.s@gmail.com}
  s.files = ["test/abstract_unit.rb", "test/acts_as_indexed_test.rb", "test/configuration_test.rb", "test/fixtures/post.rb", "test/schema.rb", "test/search_atom_test.rb", "test/search_index_test.rb"]
  s.homepage = %q{http://github.com/dougal/acts_as_indexed}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{Acts As Indexed is a plugin which provides a pain-free way to add fulltext search to your Ruby on Rails app}
  s.test_files = ["test/abstract_unit.rb", "test/acts_as_indexed_test.rb", "test/configuration_test.rb", "test/fixtures/post.rb", "test/schema.rb", "test/search_atom_test.rb", "test/search_index_test.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
