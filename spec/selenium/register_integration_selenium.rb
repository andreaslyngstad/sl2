require "selenium-webdriver"
require "spec_helper"
include RSpec::Expectations

describe "RegisterIntegrationSpec" do

  before(:each) do
    @driver = Selenium::WebDriver.for :firefox
    @base_url = "http://lvh.me:3001/"
    @driver.manage.timeouts.implicit_wait = 30
    @verification_errors = []
  end
  
  after(:each) do
    @driver.quit
    @verification_errors.should == []
  end
  
  it "test_register_integration_spec" do
    @driver.get(@base_url + "/")
    @driver.find_element(:link, "Sign up for free").click
    @driver.find_element(:id, "firm_name").clear
    @driver.find_element(:id, "firm_name").send_keys "firm"
    @driver.find_element(:id, "firm_subdomain").clear
    @driver.find_element(:id, "firm_subdomain").send_keys "firm"
    verify { element_present?(:css, "em.ok").should be_true }
    # ERROR: Caught exception [ERROR: Unsupported command [isTextPresent]]
    @driver.find_element(:id, "firm_subdomain").clear
    @driver.find_element(:id, "firm_subdomain").send_keys "firm&"
     verify { element_present?(:css, "em.error").should be_true }
    # ERROR: Caught exception [ERROR: Unsupported command [isTextPresent]]
    @driver.find_element(:id, "firm_subdomain").clear
    @driver.find_element(:id, "firm_subdomain").send_keys "firm"
    @driver.find_element(:name, "commit").click
    @driver.find_element(:id, "user_name").clear
    
    @driver.find_element(:id, "user_name").send_keys "user"
    @driver.find_element(:id, "user_email").clear
    @driver.find_element(:id, "user_email").send_keys "user@firm.com"
    @driver.find_element(:name, "commit").click
    verify { element_present?(:css, "em.error").should be_true }
    # ERROR: Caught exception [ERROR: Unsupported command [isTextPresent]]
    @driver.find_element(:id, "user_email").clear
    @driver.find_element(:id, "user_email").send_keys "userirm.com"
    @driver.find_element(:name, "commit").click
    verify { element_present?(:css, "em.error").should be_true }
    # ERROR: Caught exception [ERROR: Unsupported command [isTextPresent]]
    @driver.find_element(:id, "user_email").clear
    @driver.find_element(:id, "user_email").send_keys "user@firm.com"
    @driver.find_element(:id, "user_password").clear
    @driver.find_element(:id, "user_password").send_keys "se"
    @driver.find_element(:name, "commit").click
    verify { element_present?(:css, "em.error").should be_true }
    # ERROR: Caught exception [ERROR: Unsupported command [isTextPresent]]
    @driver.find_element(:id, "user_password").clear
    @driver.find_element(:id, "user_password").send_keys "secret"
    @driver.find_element(:name, "commit").click
    verify { element_present?(:css, "span.flash_notice > span").should be_true }
    # ERROR: Caught exception [ERROR: Unsupported command [isTextPresent]]
    # ERROR: Caught exception [ERROR: Unsupported command [isTextPresent]]
  end
  
  def element_present?(how, what)
    @driver.find_element(how, what)
    true
  rescue Selenium::WebDriver::Error::NoSuchElementError
    false
  end
  
  def verify(&blk)
    yield
  rescue ExpectationNotMetError => ex
    @verification_errors << ex
  end
end
