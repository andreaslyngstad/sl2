require "support/selenium_helper"
describe "TimesheetSpec" do
  login_at_subdomain       
  it "test_timesheet_spec" do  
    # FactoryGirl.create(:user, firm: user.firm, name: "abc" )
    @driver.get(@base_url + "/users")
    @driver.find_element(:css, "BODY").text.should =~ /^[\s\S]*user[\s\S]*$/
    @driver.find_element(:css, "span.ui-button-text").click
    form = @driver.find_element(:id, "new_user")
    form.find_element(:id, "user_name").clear
    form.find_element(:id, "user_name").send_keys "test_2" 
    form.find_element(:xpath, "(//input[@id='user_email'])").clear
    form.find_element(:xpath, "(//input[@id='user_email'])").send_keys "user2@frim.com"
    form.find_element(:xpath, "(//input[@id='user_phone'])").clear
    form.find_element(:xpath, "(//input[@id='user_phone'])").send_keys "22222222"
    form.find_element(:xpath, "(//input[@id='user_password'])").clear
    form.find_element(:xpath, "(//input[@id='user_password'])").send_keys "secret"
    form.find_element(:xpath, "(//input[@name='commit'])").click
    @driver.get(@base_url + "/logs") 
    @driver.find_element(:link, "Home").click
    # Warning: assertTextPresent may require manual changes
    html = @driver.execute_script("return $('.timesheet_for_user').text()")
    html.should include('Timesheet for ' + user.name)
    @driver.find_element(:css, "BODY").text.should =~ /^[\s\S]*Timesheet for [\s\S]*$/  
    
    @driver.execute_script('$("#timeheet_project_select_chzn").trigger("mousedown")')
    @driver.execute_script('$("#timeheet_project_select_chzn_o_1").trigger("mouseup")')
    
    @driver.execute_script('$(".form-input:eq(0)").val("1").trigger("focusout")')
    sleep 0.2
    @driver.find_element(:css, "BODY").text.should =~ /^[\s\S]*1[\s\S]*$/ 
    @driver.execute_script('$(".form-input:eq(1)").val("2").trigger("focusout")')
    sleep 0.2
    @driver.find_element(:css, "BODY").text.should =~ /^[\s\S]*3[\s\S]*$/
    @driver.execute_script('$(".form-input:eq(2)").val("3").trigger("focusout")') 
    sleep 0.2
    @driver.find_element(:css, "BODY").text.should =~ /^[\s\S]*6[\s\S]*$/
    @driver.execute_script('$("#timeheet_project_select_chzn").trigger("mousedown")')
    @driver.execute_script('$("#timeheet_project_select_chzn_o_0").trigger("mouseup")')
    @driver.execute_script('$("#timeheet_project_select_chzn").trigger("mousedown")')
    @driver.execute_script('$("#timeheet_project_select_chzn_o_1").trigger("mouseup")')
    @driver.find_element(:css, "BODY").text.should =~ /^[\s\S]*3[\s\S]*$/
    @driver.execute_script('$(".form-input:eq(1)").val("3").trigger("focusout")') 
    sleep 0.2
    html = @driver.execute_script('return $(".project_hours").first().children(".number:eq(1)").text()')
    html.should include('5')
    @driver.execute_script('$(".form-input:eq(1)").val("2").trigger("focusout")') 
    sleep 0.2
    html = @driver.execute_script('return $(".project_hours").first().children(".number:eq(1)").text()')
    html.should include('4')
    @driver.execute_script('$(".form-input:eq(3)").val("2").trigger("focusout")') 
    sleep 0.2
    html = @driver.execute_script('return $(".timesheet_week_total").text()')
    html.should include('10')
    html = @driver.execute_script('return $(".total").first().text()')
    html.should include('10')
    
    @driver.execute_script('$(".form-input:eq(4)").val("2").trigger("focusout")') 
    sleep 0.2
    html = @driver.execute_script('return $(".timesheet_week_total").text()')
    html.should include('12')
    html = @driver.execute_script('return $(".total").first().text()')
    html.should include('12')
    @driver.execute_script('$(".form-input:eq(5)").val("2").trigger("focusout")') 
    sleep 0.2
    html = @driver.execute_script('return $(".timesheet_week_total").text()')
    html.should include('14')
    html = @driver.execute_script('return $(".total").first().text()')
    html.should include('14')
    @driver.execute_script('$(".form-input:eq(6)").val("2").trigger("focusout")') 
    sleep 0.2
    html = @driver.execute_script('return $(".timesheet_week_total").text()')
    html.should include('16')
    html = @driver.execute_script('return $(".total").first().text()')
    html.should include('16') 
     
    @driver.execute_script('$("#timeheet_user_select_chzn").trigger("mousedown")') 
    @driver.execute_script('$("#timeheet_user_select_chzn").find(".chzn-results").find("li:contains(\'test_2\')").trigger("mouseup")')
    sleep 0.2
    html = @driver.execute_script("return $('.timesheet_for_user').text()")
    html.should include('Timesheet for test_2')
    @driver.execute_script('$("#timeheet_user_select_chzn").trigger("mousedown")') 
    @driver.execute_script('$("#timeheet_user_select_chzn").find(".chzn-results").find("li:contains(' + user.name.to_s + ')").trigger("mouseup")')
    sleep 0.2
    
    @driver.execute_script('window.location.href = $(".timesheet_day:eq(2) a").attr("href");')
    sleep 0.2  
    html = @driver.execute_script("return $('.event_on_log').last().text()")
    html.should include('Added on timesheet')
    
    @driver.execute_script('window.location.href = $("#month_week_tabs").find("li").last().find("a").attr("href");')
    html = @driver.execute_script('return $(".total").first().text()')
    html.should include('16')
    @driver.execute_script('window.location.href = $("#month_week_tabs").find("li").first().find("a").attr("href");')
    html = @driver.execute_script('return $("th:eq(0)").text()')
    html.should include('Monday')
    
     
    @driver.find_element(:id, "dialog_log").click
    @driver.find_element(:id, "log_event").clear
    @driver.find_element(:id, "log_event").send_keys "test"
    @driver.find_element(:id, "log_times_to_").clear
    @driver.find_element(:id, "log_times_to_").send_keys "12:34"
    @driver.find_element(:id, "log_times_from_").clear
    @driver.find_element(:id, "log_times_from_").send_keys "11:34"
    @driver.find_element(:id, "new_log_submit").click
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
