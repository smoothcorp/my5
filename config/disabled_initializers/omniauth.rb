FACEBOOK_CONFIG = YAML.load_file("#{RAILS_ROOT}/config/facebook.yml")[RAILS_ENV]

Rails.application.config.middleware.use OmniAuth::Builder do  
  provider :facebook, FACEBOOK_CONFIG['app_id'], FACEBOOK_CONFIG['secret_key']
end