# require "selenium-webdriver"
# require 'spec_helper'
# include RSpec::Expectations
# 
# describe "RegSpec" do
  # before(:all) do
    # FactoryGirl.create(:plan)
  # end
  # let!(:firm)        {FactoryGirl.create(:firm, subdomain: rand(0..1000).to_s + "sub" + rand(0..1000).to_s)}
   # let!(:user)        {FactoryGirl.create(:user, firm: firm, email: rand(0..1000).to_s + "sub" + rand(0..1000).to_s + "@tes.te") } 
  # before(:each) do
#     
    # @driver = Selenium::WebDriver.for :firefox
    # @base_url = "http://lvh.me:3000/"  
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
  # it "test_reg_spec" do
    # @driver.get(@base_url + "/")
    # @driver.find_element(:link, "Sign up for free").click
    # @driver.find_element(:id, "firm_name").clear
    # @driver.find_element(:id, "firm_name").send_keys firm.name
    # @driver.find_element(:id, "firm_subdomain").clear
    # @driver.find_element(:id, "firm_subdomain").send_keys "firm"
    # @driver.find_element(:id, "firm_subdomain").clear
    # @driver.find_element(:id, "firm_subdomain").send_keys firm.subdomain
    # @driver.find_element(:name, "commit").click
    # @driver.find_element(:name, "commit").click
    # # Warning: assertTextPresent may require manual changes
    # @driver.find_element(:css, "BODY").text.should =~ /^[\s\S]*can't be blank[\s\S]*$/
    # # Warning: assertTextPresent may require manual changes
    # @driver.find_element(:css, "BODY").text.should =~ /^[\s\S]*can't be blank[\s\S]*$/
    # # Warning: assertTextPresent may require manual changes
    # @driver.find_element(:css, "BODY").text.should =~ /^[\s\S]*can't be blank[\s\S]*$/
    # # Warning: assertTextPresent may require manual changes
    # @driver.find_element(:css, "BODY").text.should =~ /^[\s\S]*Registration could not be saved[\s\S]*$/
    # @driver.find_element(:id, "user_name").clear
    # @driver.find_element(:id, "user_name").send_keys user.name
    # @driver.find_element(:id, "user_email").clear
    # @driver.find_element(:id, "user_email").send_keys "u"
    # @driver.find_element(:id, "user_password").clear
    # @driver.find_element(:id, "user_password").send_keys "s"
    # @driver.find_element(:name, "commit").click
    # # Warning: assertTextPresent may require manual changes
    # @driver.find_element(:css, "BODY").text.should =~ /^[\s\S]*is invalid[\s\S]*$/
    # # Warning: assertTextPresent may require manual changes
    # @driver.find_element(:css, "BODY").text.should =~ /^[\s\S]*is too short \(minimum is 6 characters\)[\s\S]*$/
    # @driver.find_element(:id, "user_email").clear
    # @driver.find_element(:id, "user_email").send_keys user.email
    # @driver.find_element(:id, "user_password").clear
    # @driver.find_element(:id, "user_password").send_keys user.password
    # @driver.find_element(:name, "commit").click
    # # Warning: assertTextPresent may require manual changes
    # @driver.find_element(:css, "BODY").text.should =~ /^[\s\S]*Signed in successfully[\s\S]*$/
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
