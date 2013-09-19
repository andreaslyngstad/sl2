require File.expand_path('../boot', __FILE__)

require 'rails/all'
# require "rails/test_unit/railtie"

# If you have a Gemfile, require the gems listed there, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)


SECRETS_CONFIG = YAML.load(File.read(File.expand_path('../secrets.yml', __FILE__)))
SECRETS_CONFIG.merge! SECRETS_CONFIG.fetch(Rails.env, {})

module Squadlink
  class Application < Rails::Application

    config.colorize_logging = true
    # Enable the asset pipeline
    config.assets.enabled = true
    config.assets.precompile += %w( registration.js registration.css )
    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'
    
    config.to_prepare { 
  Devise::SessionsController.layout "registration" 
  Devise::PasswordsController.layout "registration"
	} 
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.active_record.timestamped_migrations = false
    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)
    config.autoload_paths += %W[#{config.root}/lib]
    config.active_record.schema_format = :sql
    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
     config.time_zone = 'UTC'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
    # config.i18n.default_locale = :de

    # JavaScript files you want as :defaults (application.js is always included).
    # config.action_view.javascript_expansions[:defaults] = %w(jquery rails)

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password, :password_confirmation]
  
  end
end
