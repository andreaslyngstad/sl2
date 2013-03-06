require 'spec_helper'
feature 'Sign up' do
   scenario "creating an firm and first user" do
     visit root_url
     click_link 'Sign up for free'
     fill_in 'firm_name', :with => "Test"
     fill_in 'firm_subdomain', :with => "Test"
     click_button "next"
     success_message = "Firm was successfully created! Now create the first user."
     page.should have_content(success_message)
     fill_in 'user_name', :with => 'Test'
     fill_in 'user_email', :with => 'test@example.com'
     fill_in 'user_password', :with => 'password' 
     click_button "Save"
     page.current_url.should == "http://test.example.com/"
     page.should have_content("Signed in successfully")
   end
   
   scenario 'creating an firm and first user with wrong data' do 
     visit root_url
     click_link 'Sign up for free'
     click_button "next" 
     page.should have_content ("Firm could not be created")
     page.should have_content ("can't be blank")
     page.should have_content ("is invalid")
     fill_in 'firm_name', :with => "Test"
     fill_in 'firm_subdomain', :with => "Test"
     click_button "next"
     click_button "Save"
     page.should have_content("can't be blank")
     page.should have_content("Registration could not be saved")
   end
end