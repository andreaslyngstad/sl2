module SubdomainLoginFeatures
	def get_the_gritty
		# let(:user)        {FactoryGirl.create(:user)}
  #   let(:firm)        {user.firm} 
  #   let(:project) 		{FactoryGirl.create :project, name: "test_project", firm: firm, budget:10 }				
  #   let(:customers)   {"http://#{firm.subdomain}.lvh.me:31234/customers"} 
  #   let(:root_url)    {"http://#{firm.subdomain}.lvh.me:31234/"}
    before(:all) do 
	    @user = FactoryGirl.create(:user)
	    @firm = @user.firm 
	    @project = FactoryGirl.create :project, name: "test_project", firm: @firm, budget:10 				
	    @customers = "http://#{@firm.subdomain}.lvh.me:31234/customers"
	    @root_url ="http://#{@firm.subdomain}.lvh.me:31234/"
    	@project.users << @user
      Capybara.server_port = 31234 
      sub = @firm.subdomain
      Capybara.app_host = @root_url 
    end 
	end
	
	def sign_in_on_js
    visit @root_url
    find("#login_link").click
    fill_in "user_email_popup", :with => @user.email
    fill_in "user_password_popup", :with => "password"
    click_button "sign_in"
    page.should have_content("Signed in successfully") 
	end
end
 