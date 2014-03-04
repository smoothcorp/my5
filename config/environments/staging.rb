Semblance::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.consider_all_requests_local       = true

  #config.action_mailer.default_url_options = { :host => 'localhost:3000' }
end

Refinery.rescue_not_found = false
# When true will use Amazon's Simple Storage Service on your production machine
# instead of the default file system for resources and images
Refinery.s3_backend = !(ENV['S3_KEY'].nil? || ENV['S3_SECRET'].nil?)
