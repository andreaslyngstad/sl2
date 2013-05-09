require "selenium-webdriver"
require "rspec"
require "support/subdomain_login"
include SubdomainLogin
include RSpec::Expectations

describe "CustomerCrudSpec", :slow do
  login_at_subdomain
  
  it "test_customer_crud_spec", :slow do
    @driver.get(@base_url + "/customers")
    @driver.find_element(:css, "span.ui-button-text").click
    @driver.find_element(:id, "customer_name").clear
    @driver.find_element(:id, "customer_name").send_keys "test_customer"
    @driver.find_element(:id, "customer_phone").clear
    @driver.find_element(:id, "customer_phone").send_keys "55555555"
    @driver.find_element(:id, "customer_email").clear
    @driver.find_element(:id, "customer_email").send_keys "test@customer.com"
    @driver.find_element(:id, "customer_address").clear
    @driver.find_element(:id, "customer_address").send_keys "test_street 23"
    @driver.find_element(:name, "commit").click
    # Warning: assertTextPresent may require manual changes
    @driver.find_element(:css, "BODY").text.should =~ /^[\s\S]*test_customer[\s\S]*$/
    @driver.find_element(:css, "#customer_update > span.ui-button-text").click
    @driver.find_element(:css, "input.customer_edit_name").clear
    @driver.find_element(:css, "input.customer_edit_name").send_keys "test_customer_edit"
    @driver.find_element(:id, "customer_edit_submit").click 
    sleep 1 
    # Warning: assertTextPresent may require manual changes
    @driver.find_element(:css, "BODY").text.should =~ /^[\s\S]*test_customer_edit[\s\S]*$/
    @driver.find_element(:xpath, "//li[@class='tab_list'][1]/a/span/span").click
    alert = @driver.switch_to().alert()
    alert.accept()
    sleep 1 
    # Warning: assertTextNotPresent may require manual changes
    @driver.find_element(:css, "BODY").text.should =~ /^[\s\S]*Customer was successfully deleted[\s\S]*$/
  end
end
