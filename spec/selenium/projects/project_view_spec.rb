require "support/selenium_helper"
describe "ProjectViewSpec" do

  login_at_subdomain 
  
  it "test_project_view_spec" do
    @driver.get(@base_url + "/projects")
    @driver.find_element(:css, "#dialog_project > span.ui-button-text").click
    @driver.find_element(:id, "project_name").clear
    @driver.find_element(:id, "project_name").send_keys "test_project"
    @driver.find_element(:name, "commit").click
    @driver.find_element(:link, "test_project").click
    
    @driver.find_element(:css, "#dialog_todo > span.ui-button-text").click
    @driver.find_element(:id, "todo_name").clear
    @driver.find_element(:id, "todo_name").send_keys "test_todo"
    @driver.find_element(:id, "new_todo_submit").click
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
    
    sleep 0.5 
    # Warning: waitForTextPresent may require manual changes 

    @driver.find_element(:css, "BODY").text.should =~ /^[\s\S]*Done Done by\ntest_todo_edit [\s\S]*$/
     @driver.find_element(:css,".done_box").click
    # Warning: waitForTextPresent may require manual changes
    sleep 0.5
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
    sleep 0.2
    @driver.find_element(:css, "BODY").text.should =~ /^[\s\S]*\nTask was successfully deleted\.[\s\S]*$/
    @driver.find_element(:xpath, "(//a[contains(text(),'Logs')])[2]").click
    @driver.find_element(:link, "delete").click 
    alert = @driver.switch_to().alert()
    alert.accept()
    sleep 0.2
    # Warning: waitForTextPresent may require manual changes
    @driver.find_element(:css, "BODY").text.should =~ /^[\s\S]*\nLog was deleted\.[\s\S]*$/
    
    @driver.find_element(:link, "Milestones").click
    sleep 0.2
    # Warning: assertTextPresent may require manual changes

    @driver.find_element(:css, "BODY").text.should =~ /^[\s\S]*Goal[\s\S]*$/m 
    @driver.find_element(:css, "#dialog_milestone > span.ui-button-text").click 
    @driver.find_element(:id, "milestone_goal").clear
    @driver.find_element(:id, "milestone_goal").send_keys "test_milestone" 
    @driver.find_element(:id, "new_milestone_submit").click
     sleep 0.2
    @driver.find_element(:css, "BODY").text.should =~ /^[\s\S]*test_milestone[\s\S]*$/
    @driver.find_element(:id, "milestone_update").click
    @driver.execute_script('$(".edit_milestone").first().find("#milestone_goal").val("test_milestone_edit")')
    
     @driver.execute_script('$(".edit_milestone").first().find(".submit").trigger("click")')
    # Warning: assertTextPresent may require manual changes
     sleep 0.2
    @driver.find_element(:css, "BODY").text.should =~ /^[\s\S]*test_milestone_edit[\s\S]*$/
    # Warning: assertTextPresent may require manual changes
    @driver.find_element(:css, "BODY").text.should =~ /^[\s\S]*\nMilestone was successfully updated[\s\S]*$/m
    @driver.find_element(:link, "delete").click
   alert = @driver.switch_to().alert()
    alert.accept()
    # Warning: assertTextPresent may require manual changes
     sleep 0.2
    @driver.find_element(:css, "BODY").text.should =~ /^[\s\S]*was successfully deleted[\s\S]*$/
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
