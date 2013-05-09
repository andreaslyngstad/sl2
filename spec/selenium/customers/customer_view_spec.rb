require 'spec_helper'
require "rspec"
include RSpec::Expectations
  
describe "CustomerViewCrud", :slow do  
    let(:firm)        {FactoryGirl.create(:firm)}
    let(:user)        {FactoryGirl.create(:user, firm: firm)}  
    let(:project)     {FactoryGirl.create(:project, firm: firm, active: true, name: "test_project")}  
    
  before(:all) do
    project.users << user
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
  it "test_customer_show_crud", :slow do 
    @driver.get(@base_url + "/customers")
    @driver.find_element(:css, "span.ui-button-text").click
    @driver.find_element(:id, "customer_name").clear
    @driver.find_element(:id, "customer_name").send_keys "tests"
    @driver.find_element(:name, "commit").click
    @driver.find_element(:link, "tests").click
    # Warning: waitForTextPresent may require manual changes
    sleep 0.2
    @driver.find_element(:css, "BODY").text.should =~ /^[\s\S]*Task Project Assigned to[\s\S]*$/
    @driver.find_element(:xpath, "(//a[contains(text(),'Logs')])[2]").click
    # Warning: waitForTextPresent may require manual changes
    sleep 0.2
    
    @driver.find_element(:css, "BODY").text.should =~ /^[\s\S]*Event[\s\S]*$/
    @driver.find_element(:xpath, "(//a[contains(text(),'Projects')])[2]").click
    # Warning: waitForTextPresent may require manual changes
    @driver.find_element(:css, "BODY").text.should =~ /^[\s\S]*Name Description Due[\s\S]*$/
    @driver.find_element(:link, "Employees").click
    # Warning: waitForTextPresent may require manual changes
    @driver.find_element(:css, "BODY").text.should =~ /^[\s\S]*Name Phone Email[\s\S]*$/
    @driver.find_element(:link, "Tasks").click 
    @driver.find_element(:css, "#dialog_todo > span.ui-button-text").click
    @driver.find_element(:id, "todo_name").clear
    @driver.find_element(:id, "todo_name").send_keys "test_todo"
    @driver.find_element(:id, "new_todo_submit").click
     sleep 0.2
    # Warning: verifyTextPresent may require manual changes
    @driver.find_element(:css, "BODY").text.should =~ /^[\s\S]*Sorry\nProject must be selected\.[\s\S]*$/m
    
    @driver.execute_script('$("#todoProjectId_chzn").trigger("mousedown")')
    sleep 0.2
    @driver.execute_script('$("#todoProjectId_chzn_o_1").trigger("mouseup")')
    @driver.find_element(:id, "new_todo_submit").click 
    # Warning: waitForTextPresent may require manual changes 
    sleep 0.2
    @driver.find_element(:css, "BODY").text.should =~ /^[\s\S]*test_todo[\s\S]*$/
    @driver.find_element(:css, "BODY").text.should =~ /^[\s\S]*\nTask was successfully created\.[\s\S]*$/
    @driver.find_element(:id, 'todo_update').click
    # @driver.find_element(:xpath, "todo_update").click
    @driver.find_element(:xpath, "(//textarea[@id='todo_name'])[2]").clear
    
    @driver.find_element(:xpath, "(//textarea[@id='todo_name'])[2]").send_keys "test_todo_edit"
    @driver.find_element(:id, "edit_todo_submit").click
    # Warning: waitForTextPresent may require manual changes
    sleep 0.5
    @driver.find_element(:css, "BODY").text.should =~ /^[\s\S]*test_todo_edit [\s\S]*$/
    @driver.find_element(:css,".done_box").click
    sleep 0.2
    # Warning: waitForTextPresent may require manual changes
    @driver.find_element(:css, "BODY").text.should =~ /^[\s\S]*Done Done by\ntest_todo_edit [\s\S]*$/
     @driver.find_element(:css,".done_box").click
    # Warning: waitForTextPresent may require manual changes
    sleep 0.2
    @driver.find_element(:css, "BODY").text.should =~ /^[\s\S]*Due\ntest_todo_edit[\s\S]*$/
    @driver.find_element(:xpath, "(//a[contains(text(),'Logs')])[2]").click
    @driver.find_element(:css, "#dialog_log > span.ui-button-text").click 
    @driver.execute_script('$("#logProjectId_chzn").trigger("mousedown")')
    @driver.execute_script('$("#logProjectId_chzn_o_1").trigger("mouseup")')
    sleep 0.2
    @driver.execute_script('$("#logTodoId_chzn").trigger("mousedown")')
    @driver.execute_script('$("#logTodoId_chzn_o_1").trigger("mouseup")')
   
    @driver.find_element(:id, "log_event").click
    @driver.find_element(:id, "log_event").clear
    @driver.find_element(:id, "log_event").send_keys "test_log"
    @driver.find_element(:id, "new_log_submit").click 
    @driver.find_element(:link, "Tasks").click
     sleep 0.2
    @driver.execute_script('$(".logs_pluss").first().trigger("click")')  
    # Warning: waitForTextPresent may require manual changes
    sleep 0.2
    @driver.find_element(:css, "BODY").text.should =~ /^[\s\S]*\ntest_log[\s\S]*$/
    @driver.find_element(:link, "delete").click
    alert = @driver.switch_to().alert()
    alert.accept()
    
    @driver.find_element(:xpath, "(//a[contains(text(),'Logs')])[2]").click
    @driver.find_element(:link, "delete").click 
    alert = @driver.switch_to().alert()
    alert.accept()
    sleep 0.2
    # Warning: waitForTextPresent may require manual changes
    @driver.find_element(:css, "BODY").text.should =~ /^[\s\S]*\nLog was deleted\.[\s\S]*$/
    @driver.find_element(:xpath, "(//a[contains(text(),'Projects')])[2]").click
    @driver.find_element(:css, "#dialog_project > span.ui-button-text").click
    @driver.find_element(:id, "project_name").clear
    @driver.find_element(:id, "project_name").send_keys "test_project"
    @driver.find_element(:id, "dialog_project_date").click
    @driver.find_element(:id, "dialog_project_date").clear
    @driver.find_element(:id, "dialog_project_date").send_keys "10.10.2012" 
    @driver.find_element(:id, "new_project_customer").click    
    @driver.find_element(:id, "project_update").click
    sleep 0.2
    @driver.execute_script('$(".edit_project").first().find("#project_name").val("test_project_edit")')
    @driver.find_element(:id, "submit_project_edit").click
    # Warning: waitForTextPresent may require manual changes
    sleep 0.2
    @driver.find_element(:css, "BODY").text.should =~ /^[\s\S]*test_project_edit[\s\S]*$/ 
    @driver.find_element(:link, "Employees").click
    @driver.find_element(:css, "#dialog_employees > span.ui-button-text").click
    @driver.find_element(:id, 'employee_name').clear
    @driver.find_element(:id, 'employee_name').send_keys "gunnar"  
    @driver.find_element(:id, 'new_employee_submit').click 
    sleep 0.2
    @driver.find_element(:css, "BODY").text.should =~ /^[\s\S]*gunnar[\s\S]*$/    
    @driver.find_element(:css, "BODY").text.should =~ /^[\s\S]*Employee was successfully saved.[\s\S]*$/  
    @driver.find_element(:id, "employee_update").click
    sleep 0.2
    @driver.execute_script('$(".edit_employee").first().find("#employee_name").val("gunnar_edit")')
    @driver.find_element(:id, "submit_employee_edit").click
    sleep 0.2 
    @driver.find_element(:css, "BODY").text.should =~ /^[\s\S]*gunnar_edit[\s\S]*$/    
    
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
