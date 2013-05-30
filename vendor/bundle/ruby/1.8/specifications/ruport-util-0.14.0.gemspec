# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{ruport-util}
  s.version = "0.14.0"

  s.required_rubygems_version = nil if s.respond_to? :required_rubygems_version=
  s.authors = ["Gregory Brown"]
  s.cert_chain = nil
  s.date = %q{2008-04-02}
  s.description = %q{ruport-util provides a number of utilities and helper libs for Ruby Reports}
  s.email = %q{  gregory.t.brown@gmail.com}
  s.executables = ["rope", "csv2ods"]
  s.files = ["test/test_format_xls.rb", "test/test_hpricot_traverser.rb", "test/test_query.rb", "test/test_report_manager.rb", "test/test_graph_renderer.rb", "test/test_graph_ofc.rb", "test/test_mailer.rb", "test/test_report.rb", "test/test_invoice.rb", "test/test_format_ods.rb", "test/test_ods_table.rb", "test/test_xls_table.rb", "bin/rope", "bin/csv2ods"]
  s.homepage = %q{http://code.rubyreports.org}
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new("> 0.0.0")
  s.rubyforge_project = %q{ruport}
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{A set of tools and helper libs for Ruby Reports}
  s.test_files = ["test/test_format_xls.rb", "test/test_hpricot_traverser.rb", "test/test_query.rb", "test/test_report_manager.rb", "test/test_graph_renderer.rb", "test/test_graph_ofc.rb", "test/test_mailer.rb", "test/test_report.rb", "test/test_invoice.rb", "test/test_format_ods.rb", "test/test_ods_table.rb", "test/test_xls_table.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 1

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<ruport>, [">= 1.6.0"])
      s.add_runtime_dependency(%q<mailfactory>, [">= 1.2.3"])
      s.add_runtime_dependency(%q<rubyzip>, [">= 0.9.1"])
    else
      s.add_dependency(%q<ruport>, [">= 1.6.0"])
      s.add_dependency(%q<mailfactory>, [">= 1.2.3"])
      s.add_dependency(%q<rubyzip>, [">= 0.9.1"])
    end
  else
    s.add_dependency(%q<ruport>, [">= 1.6.0"])
    s.add_dependency(%q<mailfactory>, [">= 1.2.3"])
    s.add_dependency(%q<rubyzip>, [">= 0.9.1"])
  end
end
