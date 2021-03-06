require "support/selenium_helper" 
describe "CustomerViewCrud" do  
   login_at_subdomain  
  it "test_customer_show_crud" do  
    @driver.get(@base_url + "/customers")
    @driver.find_element(:css, "span.ui-button-text").click
    @driver.find_element(:id, "customer_name").clear
    @driver.find_element(:id, "customer_name").send_keys "tests"
    @driver.find_element(:name, "commit").click 
    @driver.find_element(:link, "tests").click
    # Warning: waitForTextPresent may require manual changes
    sleep 0.2
    @driver.find_element(:css, "BODY").text.should =~ /^[\s\S]*Total hours[\s\S]*$/
    @driver.find_element(:xpath, "(//a[contains(text(),'Logs')])[2]").click
    # Warning: waitForTextPresent may require manual changes
    sleep 0.2 
    
    @driver.find_element(:xpath, "(//a[contains(text(),'Projects')])[2]").click
    # Warning: waitForTextPresent may require manual changes
    sleep 0.2
    @driver.find_element(:css, "BODY").text.should =~ /^[\s\S]*Name Description Due[\s\S]*$/
    @driver.find_element(:link, "Employees").click
    # Warning: waitForTextPresent may require manual changes
    sleep 0.2
    @driver.find_element(:css, "BODY").text.should =~ /^[\s\S]*Name Phone Email[\s\S]*$/
    @driver.find_element(:link, "Tasks").click 
    @driver.find_element(:css, "#dialog_todo > span.ui-button-text").click
    @driver.find_element(:id, "todo_name").clear
    @driver.find_element(:id, "todo_name").send_keys "test_todo"
    @driver.find_element(:id, "new_todo_submit").click
     sleep 0.2
    # Warning: verifyTextPresent may require manual changes
    @driver.find_element(:css, "BODY").text.should =~ /^[\s\S]*Sorry\nProject must be selected\.[\s\S]*$/m
    
    @driver.find_element(:css, "#todoProjectId_chosen").click
    sleep 0.2
    @driver.execute_script %Q{ $("li:contains('test_project')").trigger("mouseup")}

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
    @driver.find_element(:css, "#logProjectId_chosen").click
    sleep 0.2
    @driver.execute_script %Q{ $("li:contains('test_project')").trigger("mouseup")}
    sleep 0.2
    @driver.find_element(:css, "#logTodoId_chosen").click
    sleep 0.2
    @driver.execute_script %Q{ $("li:contains('test_todo_edit')").trigger("mouseup")}
    
   
    @driver.find_element(:id, "log_event").click
    @driver.find_element(:id, "log_event").clear
    @driver.find_element(:id, "log_event").send_keys "test_log"
    @driver.find_element(:id, "new_log_submit").click 
    sleep 0.5
    @driver.find_element(:css, "BODY").text.should =~ /^[\s\S]*test_todo_edit[\s\S]*$/
    @driver.find_element(:link, "Tasks").click
     sleep 0.2
    @driver.execute_script('$(".logs_pluss").first().trigger("click")')  
    # Warning: waitForTextPresent may require manual changes
    sleep 0.5
    @driver.find_element(:css, "BODY").text.should =~ /^[\s\S]*\ntest_log[\s\S]*$/
    @driver.find_element(:link, "delete").click 
    alert = @driver.switch_to().alert()
    alert.accept()
    # @driver.find_element(:css, "BODY").text.should =~ /^[\s\S]*\nLog was deleted\.[\s\S]*$/
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
    
    @driver.find_element(:id,'new_project').find_element(:name, "commit").click    
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
