require 'spec_helper'
feature 'home' do
  extend SubdomainHelpers
  let(:user)        {FactoryGirl.create(:user)}
  let!(:firm)       {user.firm} 
  # let(:sign_in_url) {"http://#{firm.subdomain}.example.com/users/sign_in"} 
  # let(:root_url)    {"http://#{firm.subdomain}.example.com/"}
  # let(:root_path)    {"http://example.com/"}
   let(:project)     {FactoryGirl.create(:project, firm:firm)}
   let(:statistics)  {"http://#{firm.subdomain}.example.com/statistics"} 
  # let(:timesheet)   {"http://#{firm.subdomain}.example.com/timesheets/#{user.id}"}
  let(:account)     {"http://#{firm.subdomain}.example.com/account"}
  
    before(:each) do 
     
      login_as(user, :scope => :user)  
    end
     within_account_subdomain do
    scenario "Statistics" do  
     visit statistics
     page.should have_content("Stats for users")
     page.should have_content(user.name) 
    end 
    scenario 'account' do 
     visit account
      page.should have_content("Memeber since: ") 
    end
    scenario "Statistics select" do
      
      visit statistics
      page.should have_content(firm.name)
      page.should have_content(user.name)
      # page.current_url.should == statistics
      # page.select("Stats for projects", :from => "stats")
      # page.should have_content(project.name)
    end
    
    end
     
    # scenario 'timesheets' do 
     # visit timesheet 
     #  page.should have_content("Timesheet for #{user.name}")
    # end
    
end