# require "selenium-webdriver"
# require 'spec_helper'
# 
# include RSpec::Expectations
# 
# describe "CustomerCrudSpec" do
    # let(:user)        {FactoryGirl.create(:user)}
    # let!(:firm)       {user.firm} 
  # before(:all) do
    # login_as(user, :scope => :user) 
  # end  
  # before(:each) do
#     
    # @driver = Selenium::WebDriver.for :firefox
    # @base_url = "http://#{firm.subdomain}.lvh.me:3001"
    # @accept_next_alert = true
    # @driver.manage.timeouts.implicit_wait = 30
    # @verification_errors = []
  # end
#   
  # after(:each) do
    # @driver.quit
    # @verification_errors.should == []
  # end
#   
  # it "test_customer_crud_spec" do
    # @driver.get(@base_url + "/customers")
    # @driver.find_element(:css, "span.ui-button-text").click
    # @driver.find_element(:id, "customer_name").clear
    # @driver.find_element(:id, "customer_name").send_keys "test_customer"
    # @driver.find_element(:id, "customer_phone").clear
    # @driver.find_element(:id, "customer_phone").send_keys "55555555"
    # @driver.find_element(:id, "customer_email").clear
    # @driver.find_element(:id, "customer_email").send_keys "test@customer.com"
    # @driver.find_element(:id, "customer_address").clear
    # @driver.find_element(:id, "customer_address").send_keys "test_street 23"
    # @driver.find_element(:name, "commit").click
    # # Warning: assertTextPresent may require manual changes
    # @driver.find_element(:css, "BODY").text.should =~ /^[\s\S]*test_customer[\s\S]*$/
    # @driver.find_element(:css, "#customer_update > span.ui-button-text").click
    # @driver.find_element(:xpath, "(//input[@id='customer_name'])[2]").clear
    # @driver.find_element(:xpath, "(//input[@id='customer_name'])[2]").send_keys "test_customer_edit"
    # @driver.find_element(:xpath, "(//input[@name='commit'])[2]").click
    # # Warning: assertTextPresent may require manual changes
    # @driver.find_element(:css, "BODY").text.should =~ /^[\s\S]*test_customer_edit[\s\S]*$/
    # @driver.find_element(:xpath, "//li[@id='customer_1']/a/span/span").click
    # close_alert_and_get_its_text().should =~ /^Are you sure[\s\S] This will destroy all employees at this customer$/
    # # Warning: assertTextNotPresent may require manual changes
    # @driver.find_element(:css, "BODY").text.should_not =~ /^[\s\S]*test_customer_edit[\s\S]*$/
  # end
#   
  # def element_present?(how, what)
    # @driver.find_element(how, what)
    # true
  # rescue Selenium::WebDriver::Error::NoSuchElementError
    # false
  # end
#   
  # def verify(&blk)
    # yield
  # rescue ExpectationNotMetError => ex
    # @verification_errors << ex
  # end
#   
  # def close_alert_and_get_its_text(how, what)
    # alert = @driver.switch_to().alert()
    # if (@accept_next_alert) then
      # alert.accept()
    # else
      # alert.dismiss()
    # end
    # alert.text
  # ensure
    # @accept_next_alert = true
  # end
# end
