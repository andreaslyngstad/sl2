require 'spec_helper'
require "rspec"
include RSpec::Expectations
  
describe "UserViewCrud", :slow do  
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
  it "test_user_show_crud", :slow do  
   @driver.get(@base_url + "/users")
    # Warning: assertTextPresent may require manual changes
    @driver.find_element(:css, "BODY").text.should =~ /^[\s\S]*user[\s\S]*$/
    @driver.find_element(:css, "span.ui-button-text").click
    form = @driver.find_element(:id, "new_user")
    form.find_element(:id, "user_name").clear
    form.find_element(:id, "user_name").send_keys "test_user"
    form.find_element(:xpath, "(//input[@id='user_email'])").clear
    form.find_element(:xpath, "(//input[@id='user_email'])").send_keys "test_user@example.com"
    form.find_element(:xpath, "(//input[@id='user_phone'])").clear
    form.find_element(:xpath, "(//input[@id='user_phone'])").send_keys "22222222"
    form.find_element(:xpath, "(//input[@id='user_password'])").clear
    form.find_element(:xpath, "(//input[@id='user_password'])").send_keys "secret"
    form.find_element(:xpath, "(//input[@name='commit'])").click
    # Warning: assertTextPresent may require manual changes
    sleep 0.2 
    @driver.find_element(:css, "BODY").text.should =~ /^[\s\S]*test_user[\s\S]*$/
    
    @driver.find_element(:link, "test_user").click
 
    @driver.find_element(:link, "Tasks").click 
    sleep 0.2
    @driver.find_element(:css, "#dialog_todo > span.ui-button-text").click
    sleep 0.2 
  
    @driver.execute_script('$(".new_todo").first().find("#todo_name").val("test_todo")')
    @driver.find_element(:id, "new_todo_submit").click
     sleep 0.2
    # Warning: verifyTextPresent may require manual changes
    @driver.find_element(:css, "BODY").text.should =~ /^[\s\S]*Sorry\nProject must be selected\.[\s\S]*$/m
    @driver.execute_script('$("#todoProjectId_chosen").trigger("mousedown")') 
    sleep 0.2  
    @driver.execute_script('$("#todoProjectId_chosen_o_1").trigger("mouseup")') 
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
    @driver.execute_script('$("#logProjectId_chosen").trigger("mousedown")')
    @driver.execute_script('$("#logProjectId_chosen_o_1").trigger("mouseup")')
    sleep 0.2
    @driver.execute_script('$("#logTodoId_chosen").trigger("mousedown")')
    @driver.execute_script('$("#logTodoId_chosen_o_1").trigger("mouseup")')
   
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
    sleep 0.2
    @driver.find_element(:link, "delete").click
    alert = @driver.switch_to().alert()
    alert.accept() 
    sleep 0.2
    @driver.find_element(:css, "BODY").text.should =~ /^[\s\S]*Task was successfully deleted.[\s\S]*$/
    @driver.find_element(:xpath, "(//a[contains(text(),'Logs')])[2]").click
    sleep 0.2
    @driver.find_element(:link, "delete").click 
    alert = @driver.switch_to().alert()
    alert.accept()
    sleep 0.2
    # Warning: waitForTextPresent may require manual changes
    @driver.find_element(:css, "BODY").text.should =~ /^[\s\S]*\nLog was deleted\.[\s\S]*$/
   
  end
   
 
end
