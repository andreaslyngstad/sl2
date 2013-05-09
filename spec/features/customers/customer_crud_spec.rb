# require 'spec_helper'
# 
# feature 'customer' do
# 
    # let(:user)        {FactoryGirl.create(:user)}
    # let(:firm)        {user.firm} 
    # let(:customers)   {"http://#{firm.subdomain}.lvh.me:31234/customers"} 
    # let(:root_url)    {"http://#{firm.subdomain}.lvh.me:31234/"}
    # before(:all) do 
#       
      # Capybara.server_port = 31234 
      # sub = firm.subdomain
      # Capybara.app_host = root_url 
    # end
   # def sign_in_on_js
    # visit root_url
    # fill_in "Email", :with => user.email
    # fill_in "Password", :with => "password"
    # click_button "Sign in"
    # page.should have_content("Signed in successfully.") 
   # end
#      
  # scenario "make new", js: true do
    # sign_in_on_js
    # visit customers
    # page.should have_content("Add new customer")       
    # find("#dialog_customer").click
    # page.should have_content("Create new customer")
    # fill_in "customer_name", with: "" 
    # click_button "Save"
    # page.should have_content("This field is required.")
    # fill_in "customer_name", with: "test_new customer"
    # fill_in "customer_phone", with: "123456789"
    # fill_in "customer_email", with: "test@tes.no"
    # fill_in "customer_address", with: "new customer address"
    # click_button "Save"
    # page.should have_content("test_new customer")
#     
  # end 
  # scenario "Edit customer", js: true do
    # sign_in_on_js
    # visit customers
    # page.should have_content("test_new customer")  
    # id = page.evaluate_script("$('.open_customer_update').first().attr('data-id');")
    # li = "li#customer_#{id}"
    # within(:css, li) do
      # first(".open_customer_update").click  
    # end 
    # page.should have_content("Update customer")
    # fill_in "customer_name_#{id}", with: "test_new_edit customer"
    # page.find("#edit_customer_#{id}").find(".submit").click
    # page.should have_content("test_new_edit customer") 
  # end 
  # scenario "delete customer", js: true do
    # sign_in_on_js
    # visit customers
    # id = page.evaluate_script("$('.open_customer_update').first().attr('data-id');")
    # li = "li#customer_#{id}"
    # within(:css, li) do
      # first(".button").click 
    # end
    # page.should have_content("Customer was successfully deleted.") 
  # end
# end