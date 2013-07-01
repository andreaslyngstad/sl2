require "support/selenium_helper"
describe "LogCrudSpec" do 
 login_at_subdomain  
       
  it "test_log_crud_spec", :focus do     
    @driver.get(@base_url + "/logs") 
    @driver.find_element(:id, "log_event").clear 
    @driver.find_element(:id, "log_event").send_keys "test"
    @driver.find_element(:name, "commit").click 
    # Warning: assertTextPresent may require manual changes
   sleep 0.2
    @driver.find_element(:css, "BODY").text.should =~ /^[\s\S]*Running[\s\S]*$/
    # Warning: assertTextPresent may require manual changes
    @driver.find_element(:css, "BODY").text.should =~ /^[\s\S]*test[\s\S]*$/
    @driver.find_element(:name, "commit").click
    # Warning: assertTextPresent may require manual changes
    @driver.find_element(:css, "BODY").text.should =~ /^[\s\S]*Log was successfully saved\.[\s\S]*$/
    @driver.find_element(:css, "span.ui-button-text").click
    @driver.find_element(:id, "new_log").find_element(:id, "log_event").clear
    @driver.find_element(:id, "new_log").find_element(:id, "log_event").send_keys "test2"
    # @driver.find_element(:id, "log_date_new").click
    # @driver.find_element(:link, "10").click
    # @driver.find_element(:id, "new_log").find_element(:name, 'commit').click
    sleep 10 
    # Warning: assertTextPresent may require manual changes
    @driver.find_element(:css, "BODY").text.should =~ /^[\s\S]*test2[\s\S]*$/ 
    @driver.find_element(:xpath, "(//span[@id='log_update'])[2]").click
    @driver.find_element(:css, "input.log_edit_event").clear
    @driver.find_element(:css, "input.log_edit_event").send_keys "test_edit"
    @driver.find_element(:id, "log_edit_submit").click 
    sleep 0.2    
    # Warning: assertTextPresent may require manual changes
    @driver.find_element(:css, "BODY").text.should =~ /^[\s\S]*test_edit[\s\S]*$/
 
    @driver.find_element(:xpath, "//a[@class='delete_log'][1]").click
    alert = @driver.switch_to().alert()   
    alert.accept()
    # Warning: assertTextPresent may require manual changes
    @driver.find_element(:css, "BODY").text.should =~ /^[\s\S]*Log was deleted\.[\s\S]*$/
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
