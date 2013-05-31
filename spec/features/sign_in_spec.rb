require 'spec_helper'
feature 'Sign in user' do 
  let(:user)        {FactoryGirl.create(:user)}
  let(:firm)       {user.firm} 
  let(:sign_in_url) {"http://#{firm.subdomain}.lvh.me:3000/users/sign_in"} 
  let(:root_url)    {"http://#{firm.subdomain}.lvh.me:3000/"}
  let(:root_path)    {"http://lvh.me:3000/"}
   
    scenario "at subdomain" do
      logout
      visit root_url
      page.current_url.should == sign_in_url
      page.should have_content("You need to sign in or register before continuing.")
      fill_in "Email", :with => user.email
      fill_in "Password", :with => "password"
      click_button "Sign in"
      page.should have_content("Signed in successfully")
      page.should have_content(firm.name)
      page.should have_content(user.name)
      page.current_url.should == root_url
    end
     
    scenario 'at root' do 
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