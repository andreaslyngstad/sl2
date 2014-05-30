# require 'simplecov'
# SimpleCov.start do
  
#   add_filter '/spec/'
#   add_filter '/config/'
#   add_filter '/lib/'
#   add_filter '/db/'
#   add_filter '/vendor/'
 
#   add_group 'Controllers', 'app/controllers'
#   add_group 'Models', 'app/models'
#   add_group 'Helpers', 'app/helpers'
#   add_group 'Mailers', 'app/mailers'
#   add_group 'Views', 'app/views'
#   add_group 'Admin', 'app/admin'
# end

ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'database_cleaner'
require 'factory_girl'
require 'ruby-debug'
require 'capybara/rspec'
require 'capybara/poltergeist'

Capybara.javascript_driver = :poltergeist
include Warden::Test::Helpers
Warden.test_mode!

Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|

  config.include Devise::TestHelpers, :type => :controller
  config.include Devise::TestHelpers, :type => :helper
  
  config.extend ControllerMacros, :type => :controller
  
  config.include ControllerMacros, :type => :feature
  config.include Utilities
  config.include FactoryGirl::Syntax::Methods
  config.include RequestMacros, :type => :request
  config.mock_with :rspec
  config.include MailerMacros
  config.before(:each) { reset_email }
  config.use_transactional_examples = false
  config.use_transactional_fixtures = false
  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end
  
  config.after(:each) do
    # Capybara.reset_sessions!
    DatabaseCleaner.clean
  end
  config.infer_base_class_for_anonymous_controllers = false
  
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true

  config.filter_run_excluding :slow unless ENV["SLOW_SPECS"]
  # config.before(:each) { GC.disable }
  # config.after(:each) { GC.enable }
  config.before(:all) { DeferredGarbageCollection.start }
  config.after(:all) { DeferredGarbageCollection.reconsider }
end
