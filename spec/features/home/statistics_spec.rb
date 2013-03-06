require 'spec_helper'
feature 'home' do
  
  let(:user)        {FactoryGirl.create(:user)}
  let!(:firm)       {user.firm} 
  let(:sign_in_url) {"http://#{firm.subdomain}.example.com/users/sign_in"} 
  let(:root_url)    {"http://#{firm.subdomain}.example.com/"}
  let(:root_path)    {"http://example.com/"}
  let(:project)     {FactoryGirl.create(:project, firm:firm)}
  let(:statistics)  {"http://#{firm.subdomain}.lvh.me:3001/statistics"} 
  let(:timesheet)   {"http://#{firm.subdomain}.example.com/timesheets/#{user.id}"}
  let(:account)     {"http://#{firm.subdomain}.example.com/account"}
  
    before(:each) do
      login_as(user, :scope => :user) 
    end
     
    scenario "Statistics" do 
     visit statistics
     page.should have_content("Stats for users")
     page.should have_content(user.name) 
    end 
    scenario "Statistics select", :js => true do 
      visit statistics
      # page.current_url.should == sign_in_url
      # page.should have_content("You need to sign in or register before continuing.")
      # fill_in "Email", :with => firm.users.first.email
      # fill_in "Password", :with => "password"
      # click_button "Sign in"
      # page.should have_content("Signed in successfully.")
      page.should have_content(firm.name)
      page.should have_content(user.name)
      page.current_url.should == root_url
     # visit statistics
     # page.should have_content("Statistics")
#      
     # page.select("Stats for projects", :from => "stats")
     # page.should have_content(project.name)
    end
    
    
     
    scenario 'timesheets' do 
     visit timesheet
     page.should have_content("Timesheet for #{user.name}")
    end
    scenario 'account' do 
     visit account
      page.should have_content("Memeber since: ") 
    end
end