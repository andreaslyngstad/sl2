require 'spec_helper'

describe "Logs integration" do

  before(:each) do
     @firm = FactoryGirl.build(:firm)#denne lager et firma
     @user = FactoryGirl.build(:user)
     visit '/register'
     fill_in 'firm_name', :with => @firm.name #derfor funker ikke dette. her lages et nytt firma
     fill_in 'firm_subdomain', :with => @firm.subdomain
     click_link_or_button('next')
     page.should have_content('Last step') 
      
     visit '/register/' + Firm.last.id.to_s + '/user'
     page.has_content?("Last step")
     fill_in 'user_name', :with => @user.name
     fill_in 'user_email', :with => @user.email
     fill_in 'user_password', :with => @user.password
     click_link_or_button('Save')
     page.should have_content("You have been logged in")
  end
  
  
   it "should make log" do   
    click_link_or_button('Logs')
    page.should have_content("Add log")
   
    find("#dialog_log").click
    find('log_event')
    fill_in 'log_event', :with => "test"
    click_link_or_button('Save')
    page.should have_content("Log was successfully created")
   end
#  it "shows logs event" do
#    log = Log.create!(event: "Tofu")
#    visit logs_url(:subdomain => @firm.subdomain, :host => "lvh.me", :port => "3000" )
#    page.text.must_include "Tofu"
#  end

end


