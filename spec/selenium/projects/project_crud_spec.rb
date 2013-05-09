require "selenium-webdriver"
require "rspec"
include RSpec::Expectations

describe "ProjectCrudSpec" do

    let(:firm)        {FactoryGirl.create(:firm)}
    let(:user)        {FactoryGirl.create(:user, firm: firm)}  
    
    
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
  
  it "test_project_crud_spec", :slow do
    @driver.get(@base_url + "/projects")
    @driver.find_element(:css, "#dialog_project > span.ui-button-text").click
    @driver.find_element(:id, "project_name").clear
    @driver.find_element(:id, "project_name").send_keys "test_project"
    @driver.find_element(:name, "commit").click 
    # Warning: assertTextPresent may require manual changes
    @driver.find_element(:css, "BODY").text.should =~ /^[\s\S]*test_project[\s\S]*$/
    @driver.find_element(:css, "#project_update > span.ui-button-text").click
    sleep 0.2
    @driver.execute_script('$(".edit_project").first().find("#project_name").val("test_project_edit")')
    @driver.find_element(:id, "submit_project_edit").click
    # Warning: assertTextPresent may require manual changes
    sleep 0.2
    @driver.find_element(:css, "BODY").text.should =~ /^[\s\S]*\nProject was successfully saved\.[\s\S]*$/m
    # Warning: assertTextPresent may require manual changes
    @driver.find_element(:css, "BODY").text.should =~ /^[\s\S]*test_project_edit[\s\S]*$/
    @driver.execute_script('$(".activate_project").first().trigger("click")')
    alert = @driver.switch_to().alert()
    alert.accept()
    sleep 0.2
    @driver.find_element(:css, "BODY").text.should =~ /^[\s\S]*\nProject is made inactive\.[\s\S]*$/m
    @driver.find_element(:css, "span.ui-button-text").click
    @driver.execute_script('$(".reopen_project").first().trigger("click")')
    @driver.find_element(:css, "span.ui-button-text").click
    # Warning: assertTextPresent may require manual changes
    @driver.find_element(:css, "BODY").text.should =~ /^[\s\S]*test_project_edit[\s\S]*$/
    @driver.execute_script('$(".activate_project").first().trigger("click")')
    alert = @driver.switch_to().alert()
    alert.accept()
    @driver.find_element(:css, "span.ui-button-text").click
    @driver.execute_script('$(".button").first().trigger("click")') 
    
  
    alert = @driver.switch_to().alert()
    alert.accept() 
    sleep 0.2 
    @driver.find_element(:css, "BODY").text.should =~ /^[\s\S]*Project was deleted[\s\S]*$/
  end
end
