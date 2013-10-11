require 'spec_helper'
require 'features/subdomain_login_features'
include SubdomainLoginFeatures

feature 'the firm is closed due to no payment' do
	get_the_gritty
	scenario 'log_in no payment' do
		@firm.closed = true
		@firm.save
		sign_in_on_js
		page.should have_content("We have not recived payment and your account is locked.")
	end
end

feature 'the user is a external user' do
	get_the_gritty
	scenario 'what does the user see' do
		sign_in_on_js
		page.should have_content("Projects")
		page.should have_content("Customers")
		click_link 'Projects'
		page.should have_content("New project")
		page.should have_content("test_project")
		click_link 'Sign out'
		
		@user = FactoryGirl.create(:user, role: 'External user', firm: @firm)
		
		sign_in_on_js
		page.should_not have_content("test_project")
		page.should_not have_content("Customers")
		click_link 'Projects'
		page.should_not have_content("New project")
		page.should_not have_content("test_project")
		# page.should_not have_content("Users")
	end
end