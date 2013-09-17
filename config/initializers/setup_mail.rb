if Rails.env != 'test'
  ActionMailer::Base.smtp_settings = SECRETS_CONFIG[Rails.env][:email] unless SECRETS_CONFIG[Rails.env].nil?
end

ActionMailer::Base.default_url_options[:host] = "squadlink.com"