source 'http://rubygems.org'

##--- Essential ---
gem 'rails', '~> 3.0.9'
gem 'jquery-rails'
gem 'ruby-debug', :platform => :mri_18
gem 'ruby-debug19', :platform => :mri_19

##--- Visuals ---
gem 'compass', '>= 0.11.5'
gem 'compass-960-plugin'
gem 'haml'
gem 'refinerycms'
gem 'cancan'
gem 'fancy-buttons'
gem 'formtastic'
gem 'barista'
gem 'googlecharts'
gem 'seer'
gem 'httparty'

##--- Utilities ---
gem 'meta_where'
gem 'decent_exposure'
gem 'paperclip'
gem 'activemerchant'
gem 'find_by_param'
gem 'recaptcha', :require => "recaptcha/rails"
gem 'yaml_db'
gem "remotipart", "~> 1.0"
gem "time_diff"
gem 'time_of_day'
gem 'execjs'
gem 'therubyracer'
gem 'newrelic_rpm'

##--- Dev and test specific
group :development, :test do
  gem 'sqlite3', :platform => :mri_19
  gem 'sqlite3-ruby', '1.2.5', :require => 'sqlite3', :platform => :mri_18
  gem "rspec-rails", "~> 2.6"
end

group :test do
  gem 'rspec', "~> 2.6"
  gem "rspec-rails", "~> 2.6"
  gem 'timecop'
  gem 'factory_girl_rails'
  gem 'refinerycms-testing'
end

##--- Production specific
gem 'mysql2', '0.2.6'

#--- Refinery Engines ---
gem 'refinerycms-subscriptions', '1.0', :path => 'vendor/engines'
gem 'refinerycms-mini_modules', '1.0', :path => 'vendor/engines'
gem 'refinerycms-audio_programs', '1.0', :path => 'vendor/engines'
gem 'refinerycms-videos', '1.0', :path => 'vendor/engines'
gem 'refinerycms-symptomatics', '1.0', :path => 'vendor/engines'
gem 'refinerycms-audios', '1.0', :path => 'vendor/engines'
gem 'refinerycms-my_eqs', '1.0', :path => 'vendor/engines'
gem 'refinerycms-customers', :path => 'vendor/engines'
gem 'refinerycms-corporations', '1.0', :path => 'vendor/engines'

##--- Logging and reporting
gem 'eventlogger', '0.0.2',  :git => 'git://github.com/semblancesystems/eventlogger.git'
gem 'ruport'
gem 'acts_as_reportable'
gem 'ruport-util'
gem 'comma', :git => 'git://github.com/chexton/comma.git'
gem 'spreadsheet'
gem 'garb'

##-- Mailer Testing
gem 'tilt'
gem 'mail_view', :git => 'git://github.com/37signals/mail_view.git'

gem 'refinerycms-programs', '1.0', :path => 'vendor/engines'
