source 'http://rubygems.org'


gem 'rails', '3.2.1'
gem 'eventmachine'
# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'
gem 'rack-ssl'
gem 'sqlite3', :require => 'sqlite3'
gem 'jquery-rails'
gem "devise"
gem "paperclip"
gem "cancan"
gem 'newrelic_rpm'
gem "watu_table_builder", :require => "table_builder", :git => "git://github.com/watu/table_builder.git"

group :production do
  gem 'pg'
end

group :assets do
  gem 'sass-rails', "  ~> 3.2.3"
  gem 'coffee-rails', "~> 3.2.1"
  gem 'uglifier', '>= 1.0.3'
  gem 'jquery-ui-rails'
end

group :development, :test do
  gem 'quiet_assets'
  gem 'debugger'
  
  gem "rspec-rails", "~> 2.0"
  gem 'capybara'
  gem "factory_girl_rails", "~> 4.0"
  #gem 'turn' 
  #gem "spork-minitest", "~> 1.0.0.beta1"
  gem 'database_cleaner'
  gem "selenium-webdriver"
  gem "selenium-client"
end

# Use unicorn as the web server
# gem 'unicorn'

gem 'capistrano'

# To use debugger
# gem 'ruby-debug'

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:

