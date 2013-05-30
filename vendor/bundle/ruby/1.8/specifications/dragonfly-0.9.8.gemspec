# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{dragonfly}
  s.version = "0.9.8"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Mark Evans"]
  s.date = %q{2011-09-08}
  s.description = %q{Dragonfly is a framework that enables on-the-fly processing for any content type.
  It is especially suited to image handling. Its uses range from image thumbnails to standard attachments to on-demand text generation.}
  s.email = %q{mark@new-bamboo.co.uk}
  s.files = ["spec/dragonfly/active_model_extensions/model_spec.rb", "spec/dragonfly/active_model_extensions/spec_helper.rb", "spec/dragonfly/analyser_spec.rb", "spec/dragonfly/analysis/file_command_analyser_spec.rb", "spec/dragonfly/app_spec.rb", "spec/dragonfly/configurable_spec.rb", "spec/dragonfly/cookie_monster_spec.rb", "spec/dragonfly/core_ext/array_spec.rb", "spec/dragonfly/core_ext/hash_spec.rb", "spec/dragonfly/core_ext/string_spec.rb", "spec/dragonfly/core_ext/symbol_spec.rb", "spec/dragonfly/data_storage/couch_data_store_spec.rb", "spec/dragonfly/data_storage/file_data_store_spec.rb", "spec/dragonfly/data_storage/mongo_data_store_spec.rb", "spec/dragonfly/data_storage/s3_data_store_spec.rb", "spec/dragonfly/data_storage/shared_data_store_examples.rb", "spec/dragonfly/function_manager_spec.rb", "spec/dragonfly/hash_with_css_style_keys_spec.rb", "spec/dragonfly/image_magick/analyser_spec.rb", "spec/dragonfly/image_magick/encoder_spec.rb", "spec/dragonfly/image_magick/generator_spec.rb", "spec/dragonfly/image_magick/processor_spec.rb", "spec/dragonfly/job_builder_spec.rb", "spec/dragonfly/job_definitions_spec.rb", "spec/dragonfly/job_endpoint_spec.rb", "spec/dragonfly/job_spec.rb", "spec/dragonfly/loggable_spec.rb", "spec/dragonfly/middleware_spec.rb", "spec/dragonfly/routed_endpoint_spec.rb", "spec/dragonfly/serializer_spec.rb", "spec/dragonfly/server_spec.rb", "spec/dragonfly/shell_spec.rb", "spec/dragonfly/simple_cache_spec.rb", "spec/dragonfly/temp_object_spec.rb", "spec/dragonfly/url_mapper_spec.rb", "spec/functional/deprecations_spec.rb", "spec/functional/image_magick_app_spec.rb", "spec/functional/model_urls_spec.rb", "spec/functional/remote_on_the_fly_spec.rb", "spec/functional/shell_commands_spec.rb", "spec/functional/to_response_spec.rb", "spec/spec_helper.rb", "spec/support/argument_matchers.rb", "spec/support/image_matchers.rb", "spec/support/simple_matchers.rb"]
  s.homepage = %q{http://github.com/markevans/dragonfly}
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{Ideal gem for handling attachments in Rails, Sinatra and Rack applications.}
  s.test_files = ["spec/dragonfly/active_model_extensions/model_spec.rb", "spec/dragonfly/active_model_extensions/spec_helper.rb", "spec/dragonfly/analyser_spec.rb", "spec/dragonfly/analysis/file_command_analyser_spec.rb", "spec/dragonfly/app_spec.rb", "spec/dragonfly/configurable_spec.rb", "spec/dragonfly/cookie_monster_spec.rb", "spec/dragonfly/core_ext/array_spec.rb", "spec/dragonfly/core_ext/hash_spec.rb", "spec/dragonfly/core_ext/string_spec.rb", "spec/dragonfly/core_ext/symbol_spec.rb", "spec/dragonfly/data_storage/couch_data_store_spec.rb", "spec/dragonfly/data_storage/file_data_store_spec.rb", "spec/dragonfly/data_storage/mongo_data_store_spec.rb", "spec/dragonfly/data_storage/s3_data_store_spec.rb", "spec/dragonfly/data_storage/shared_data_store_examples.rb", "spec/dragonfly/function_manager_spec.rb", "spec/dragonfly/hash_with_css_style_keys_spec.rb", "spec/dragonfly/image_magick/analyser_spec.rb", "spec/dragonfly/image_magick/encoder_spec.rb", "spec/dragonfly/image_magick/generator_spec.rb", "spec/dragonfly/image_magick/processor_spec.rb", "spec/dragonfly/job_builder_spec.rb", "spec/dragonfly/job_definitions_spec.rb", "spec/dragonfly/job_endpoint_spec.rb", "spec/dragonfly/job_spec.rb", "spec/dragonfly/loggable_spec.rb", "spec/dragonfly/middleware_spec.rb", "spec/dragonfly/routed_endpoint_spec.rb", "spec/dragonfly/serializer_spec.rb", "spec/dragonfly/server_spec.rb", "spec/dragonfly/shell_spec.rb", "spec/dragonfly/simple_cache_spec.rb", "spec/dragonfly/temp_object_spec.rb", "spec/dragonfly/url_mapper_spec.rb", "spec/functional/deprecations_spec.rb", "spec/functional/image_magick_app_spec.rb", "spec/functional/model_urls_spec.rb", "spec/functional/remote_on_the_fly_spec.rb", "spec/functional/shell_commands_spec.rb", "spec/functional/to_response_spec.rb", "spec/spec_helper.rb", "spec/support/argument_matchers.rb", "spec/support/image_matchers.rb", "spec/support/simple_matchers.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rack>, [">= 0"])
      s.add_development_dependency(%q<capybara>, [">= 0"])
      s.add_development_dependency(%q<cucumber>, ["~> 0.10.0"])
      s.add_development_dependency(%q<cucumber-rails>, ["~> 0.5.2"])
      s.add_development_dependency(%q<database_cleaner>, [">= 0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.5.2"])
      s.add_development_dependency(%q<fog>, [">= 0"])
      s.add_development_dependency(%q<mongo>, [">= 0"])
      s.add_development_dependency(%q<couchrest>, ["~> 1.0"])
      s.add_development_dependency(%q<rack-cache>, [">= 0"])
      s.add_development_dependency(%q<rails>, ["~> 3.1.0"])
      s.add_development_dependency(%q<rspec>, ["~> 2.5"])
      s.add_development_dependency(%q<webmock>, [">= 0"])
      s.add_development_dependency(%q<yard>, [">= 0"])
      s.add_development_dependency(%q<bluecloth>, [">= 0"])
      s.add_development_dependency(%q<bson_ext>, [">= 0"])
      s.add_development_dependency(%q<sqlite3-ruby>, [">= 0"])
    else
      s.add_dependency(%q<rack>, [">= 0"])
      s.add_dependency(%q<capybara>, [">= 0"])
      s.add_dependency(%q<cucumber>, ["~> 0.10.0"])
      s.add_dependency(%q<cucumber-rails>, ["~> 0.5.2"])
      s.add_dependency(%q<database_cleaner>, [">= 0"])
      s.add_dependency(%q<jeweler>, ["~> 1.5.2"])
      s.add_dependency(%q<fog>, [">= 0"])
      s.add_dependency(%q<mongo>, [">= 0"])
      s.add_dependency(%q<couchrest>, ["~> 1.0"])
      s.add_dependency(%q<rack-cache>, [">= 0"])
      s.add_dependency(%q<rails>, ["~> 3.1.0"])
      s.add_dependency(%q<rspec>, ["~> 2.5"])
      s.add_dependency(%q<webmock>, [">= 0"])
      s.add_dependency(%q<yard>, [">= 0"])
      s.add_dependency(%q<bluecloth>, [">= 0"])
      s.add_dependency(%q<bson_ext>, [">= 0"])
      s.add_dependency(%q<sqlite3-ruby>, [">= 0"])
    end
  else
    s.add_dependency(%q<rack>, [">= 0"])
    s.add_dependency(%q<capybara>, [">= 0"])
    s.add_dependency(%q<cucumber>, ["~> 0.10.0"])
    s.add_dependency(%q<cucumber-rails>, ["~> 0.5.2"])
    s.add_dependency(%q<database_cleaner>, [">= 0"])
    s.add_dependency(%q<jeweler>, ["~> 1.5.2"])
    s.add_dependency(%q<fog>, [">= 0"])
    s.add_dependency(%q<mongo>, [">= 0"])
    s.add_dependency(%q<couchrest>, ["~> 1.0"])
    s.add_dependency(%q<rack-cache>, [">= 0"])
    s.add_dependency(%q<rails>, ["~> 3.1.0"])
    s.add_dependency(%q<rspec>, ["~> 2.5"])
    s.add_dependency(%q<webmock>, [">= 0"])
    s.add_dependency(%q<yard>, [">= 0"])
    s.add_dependency(%q<bluecloth>, [">= 0"])
    s.add_dependency(%q<bson_ext>, [">= 0"])
    s.add_dependency(%q<sqlite3-ruby>, [">= 0"])
  end
end
