# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'database_cleaner'

require "selenium/client"

def wait_for_ajax(timeout=5000)
          js_condition = 'selenium.browserbot.getUserWindow().jQuery.active == 0'
          @selenium_driver.wait_for_condition(js_condition, timeout)
end
      
def selenium_setup

      @verification_errors = []
      @selenium_driver = Selenium::Client::Driver.new \
      :host => "localhost",
      :port => 4444,
      :browser => "*firefox",
      :url => "http://localhost:3001/",
      :timeout_in_second => 60
      #return @selenium_driver
      
end

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  
  config.use_transactional_fixtures = false
 
  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
  end
   
  config.before(:each) do
    DatabaseCleaner.start
  end
   
  config.after(:each) do
    DatabaseCleaner.clean
  end
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  # config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
 
  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false
end
