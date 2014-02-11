require "selenium-webdriver"
require "rspec"
include RSpec::Expectations

describe "UserCrud", :slow do
    let(:firm)        {FactoryGirl.create(:firm)}
    let(:user)        {FactoryGirl.create(:user, firm: firm)}  
    let(:project)     {FactoryGirl.create(:project, firm: firm, active: true, name: "test_project")}  
  
  before(:all) do
    @driver = Selenium::WebDriver.for :firefox
    @base_url = "http://#{firm.subdomain}.lvh.me:3001"   
    @driver.get(@base_url + "/")
    @accept_next_alert = true
    @driver.manage.timeouts.implicit_wait = 30
    @verification_errors = []
    @driver.find_element(:id, "user_email").send_keys user.email
    @driver.find_element(:id, "user_password").send_keys user.password 
    @driver.find_element(:name, "commit").click 
    @driver.find_element(:css, "BODY").text.should =~ /^[\s\S]*Signed in[\s\S]*$/
  end
  after(:each) do
    @driver.quit
    @verification_errors.should == []
  end
  
  
  it "test_user_crud" do
    @driver.get(@base_url + "/users")
    # Warning: assertTextPresent may require manual changes
    @driver.find_element(:css, "BODY").text.should =~ /^[\s\S]*user[\s\S]*$/
    @driver.find_element(:css, "span.ui-button-text").click
    form = @driver.find_element(:id, "new_user")
    form.find_element(:id, "user_name").clear
    form.find_element(:id, "user_name").send_keys "user2"
    form.find_element(:xpath, "(//input[@name='commit'])").click
   
    # Warning: assertTextPresent may require manual changes
    @driver.find_element(:css, "BODY").text.should =~ /^[\s\S]*This field is required\.[\s\S]*$/
    form.find_element(:xpath, "(//input[@id='user_email'])").clear
    form.find_element(:xpath, "(//input[@id='user_email'])").send_keys "user2@frim.com"
    form.find_element(:xpath, "(//input[@id='user_phone'])").clear
    form.find_element(:xpath, "(//input[@id='user_phone'])").send_keys "22222222"
    form.find_element(:xpath, "(//input[@id='user_password'])").clear
    form.find_element(:xpath, "(//input[@id='user_password'])").send_keys "secret"
    form.find_element(:xpath, "(//input[@name='commit'])").click
    # Warning: assertTextPresent may require manual changes
    sleep 0.2 
    @driver.find_element(:css, "BODY").text.should =~ /^[\s\S]*user2[\s\S]*$/
      
    @driver.find_element(:xpath, "(//span[@id='user_update'])[1]").click
    edit_form = @driver.find_element(:xpath, "(//form[@class='edit_user'])[1]")
    edit_form.find_element(:id, "user_name").clear
    edit_form.find_element(:id, "user_name").send_keys "user2_edit"
    edit_form.find_element(:class, "submit").click
    sleep 0.2 
    # Warning: assertTextPresent may require manual changes
    @driver.find_element(:css, "BODY").text.should =~ /^[\s\S]*user2_edit[\s\S]*$/
    @driver.find_element(:xpath, "//li[@class='tab_list'][1]/a/span/span").click
    alert = @driver.switch_to().alert()
    alert.accept()
    sleep 0.2 
    # Warning: assertTextNotPresent may require manual changes
    @driver.find_element(:css, "BODY").text.should =~ /^[\s\S]*You are logged in as user2_edit. You cannot delete yourself.[\s\S]*$/
    @driver.find_element(:xpath, "//li[@class='tab_list'][2]/a/span/span").click 
    alert = @driver.switch_to().alert()
    alert.accept()
    sleep 0.2
    @driver.find_element(:css, "BODY").text.should =~ /^[\s\S]*was deleted[\s\S]*$/
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
