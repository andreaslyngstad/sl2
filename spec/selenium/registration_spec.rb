require "support/selenium_helper"
describe "Registration" do 
  
  before(:all) do
    p = Plan.first
    unless p
      Plan.create(paymill_id: 2) 
    end
    @driver = Selenium::WebDriver.for :chrome
    @base_url = "http://lvh.me:3001"   
    @driver.get(@base_url + "/")
    @accept_next_alert = true
    @driver.manage.timeouts.implicit_wait = 30
    @verification_errors = []
  end
  after(:each) do
    @driver.quit
    @verification_errors.should == []
  end 
    
  it "test_registration" do 
   
    @driver.find_element(:link, "Sign up for free").click
    @driver.find_element(:id, "firm_name").clear
    @driver.find_element(:id, "firm_name").send_keys "firm"
    @driver.find_element(:id, "firm_subdomain").clear
    @driver.find_element(:id, "firm_subdomain").send_keys "firm@"
    @driver.find_element(:id, "firm_subdomain").clear
    @driver.find_element(:id, "firm_subdomain").send_keys "fiws"

    @driver.find_element(:id, "next").click

    @driver.find_element(:id, "save").click 
    sleep 0.5 
    # Warning: assertTextPresent may require manual changes
    @driver.find_element(:css, "BODY").text.should =~ /^[\s\S]*can't be blank[\s\S]*$/
    # Warning: assertTextPresent may require manual changes
    @driver.find_element(:css, "BODY").text.should =~ /^[\s\S]*can't be blank[\s\S]*$/
    # Warning: assertTextPresent may require manual changes
    @driver.find_element(:css, "BODY").text.should =~ /^[\s\S]*can't be blank[\s\S]*$/
    # Warning: assertTextPresent may require manual changes
    @driver.find_element(:css, "BODY").text.should =~ /^[\s\S]*Registration could not be saved[\s\S]*$/
    @driver.find_element(:id, "user_name").clear
    @driver.find_element(:id, "user_name").send_keys "user"
    @driver.find_element(:id, "user_email_reg").clear
    @driver.find_element(:id, "user_email_reg").send_keys "u"
    @driver.find_element(:id, "user_password_reg").clear
    @driver.find_element(:id, "user_password_reg").send_keys "s"
    @driver.find_element(:id, "save").click
    # Warning: assertTextPresent may require manual changes
    @driver.find_element(:css, "BODY").text.should =~ /^[\s\S]*is invalid[\s\S]*$/
    # Warning: assertTextPresent may require manual changes
    @driver.find_element(:css, "BODY").text.should =~ /^[\s\S]*is too short \(minimum is 6 characters\)[\s\S]*$/
    @driver.find_element(:id, "user_email_reg").clear
    @driver.find_element(:id, "user_email_reg").send_keys "user@fwis1.com"
    @driver.find_element(:id, "user_password_reg").clear
    @driver.find_element(:id, "user_password_reg").send_keys "secret"
    @driver.find_element(:id, "save").click
    # Warning: assertTextPresent may require manual changes
    @driver.find_element(:css, "BODY").text.should =~ /^[\s\S]*Registration successful.[\s\S]*$/
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
  
  def close_alert_and_get_its_text(how, what)
    alert = @driver.switch_to().alert()
    if (@accept_next_alert) then
      alert.accept()
    else
      alert.dismiss()
    end
    alert.text
  ensure
    @accept_next_alert = true
  end
end
