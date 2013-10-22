Squadlink::Application.configure do
  # Settings specified here will take precedence over those in config/environment.rb
  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.

  #################This works! Don't need exception emails in dev ####################
  # config.middleware.use ExceptionNotification::Rack,
  # :email => {
  #   :email_prefix => "[ERROR] ",
  #   :sender_address => %{no_reply@squadlink.com},
  #   :exception_recipients => %w{andreas@squadlink.com}
  # }
  ####################################################################################


  config.cache_classes = false
  config.eager_load = false
  # config.force_ssl = true
	config.middleware.use Rack::LiveReload
	Paperclip.options[:command_path] = "C:/ImageM~1"
  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  # config.action_view.debug_rjs             = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = true

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_mailer.default_url_options = { :host => 'localhost:3000' }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {:address => "localhost", :port => 1025}
  # Do not compress assets
   # Raise exception on mass assignment protection for Active Record models

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)

  config.log_tags = []
# Expands the lines which load the assets
  config.assets.debug = true
#  config.after_initialize do
#  Bullet.enable = true 
#  Bullet.alert = true
#  Bullet.bullet_logger = true  
#  Bullet.console = true
#  Bullet.growl = false
# 
#  Bullet.rails_logger = true
#  Bullet.disable_browser_cache = true
#  end
  # config.dev_tweaks.autoload_rules do
    # keep :all
#   
    # skip '/favicon.ico'
    # skip :assets
    # skip :xhr
    # keep :forced
  # end
  # config.dev_tweaks.log_autoload_notice = false
end

