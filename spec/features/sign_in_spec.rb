require 'spec_helper'
feature 'Sign in user' do 
  let(:user)        {FactoryGirl.create(:user)}
  let!(:firm)       {user.firm} 
  let(:sign_in_url) {"http://#{firm.subdomain}.example.com/users/sign_in"} 
  let(:root_url)    {"http://#{firm.subdomain}.example.com/"}
  let(:root_path)    {"http://example.com/"}
 
    scenario "Signing in user at subdomain" do
      visit root_url
      page.current_url.should == sign_in_url
      page.should have_content("You need to sign in or register before continuing.")
      fill_in "Email", :with => firm.users.first.email
      fill_in "Password", :with => "password"
      click_button "Sign in"
      page.should have_content("Signed in successfully.")
      page.should have_content(firm.name)
      page.should have_content(user.name)
      page.current_url.should == root_url
    end
     
    scenario 'Signing in user at root' do 
      visit root_path
      find("#login_link").click
      fill_in "user_email", :with => firm.users.first.email
      fill_in "user_password", :with => "password"
      click_button "Sign in"
      page.current_url.should == root_url
      page.should have_content(firm.name)
      page.should have_content(user.name)
      page.should have_content("Signed in successfully")
    end
end