Squadlink::Application.configure do
  # Settings specified here will take precedence over those in config/environment.rb
 config.middleware.use ExceptionNotification::Rack,
  :email => {
    :email_prefix => "[ERROR] ",
    :sender_address => %{no_reply@squadlink.com>},
    :exception_recipients => %w{andreas@squadlink.com}
  }
  # The production environment is meant for finished, "live" apps.
  # Code is not reloaded between requests
  config.cache_classes = true
  # config.force_ssl = true
  # config.ssl_options = {hsts: {subdomains: true}}
  config.eager_load = true
  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Specifies the header that your server uses for sending files
  config.action_dispatch.x_sendfile_header = "X-Sendfile"

  #For nginx:
  config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect'



 # Disable Rails's static asset server (Apache or nginx will already do this).
  config.serve_static_assets = false

  # Compress JavaScripts and CSS.
  config.assets.js_compressor = :uglifier
  config.assets.css_compressor = :yui
  # Enable serving of images, stylesheets, and javascripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify
  # Compress JavaScripts and CSS
  config.assets.compress = true

  # Don't fallback to assets pipeline if a precompiled asset is missed
   config.assets.compile = false
  
  # Generate digests for assets URLs
  config.assets.digest = true
  # Use default logging formatter so that PID and timestamp are not suppressed.
  config.log_formatter = ::Logger::Formatter.new
end
