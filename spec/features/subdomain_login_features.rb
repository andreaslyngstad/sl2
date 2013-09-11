module SubdomainLoginFeatures
	def get_the_gritty
		# let(:user)        {FactoryGirl.create(:user)}
  #   let(:firm)        {user.firm} 
  #   let(:project) 		{FactoryGirl.create :project, name: "test_project", firm: firm, budget:10 }				
  #   let(:customers)   {"http://#{firm.subdomain}.lvh.me:31234/customers"} 
  #   let(:root_url)    {"http://#{firm.subdomain}.lvh.me:31234/"}
    before(:all) do 
      date = Date.today == "Monday".to_date ? Date.today + 1.day : Date.today
	    @user = FactoryGirl.create(:user)
	    @firm = @user.firm 
	    @project = FactoryGirl.create :project, name: "test_project", firm: @firm, budget:10 	
      @task = Todo.create!(name: 'test_task', firm: @firm, project: @project, due: Date.today, user: @user)			
	    @customers = "http://#{@firm.subdomain}.lvh.me:31234/customers"
      @projects = "http://#{@firm.subdomain}.lvh.me:31234/projects"
      @users = "http://#{@firm.subdomain}.lvh.me:31234/users"
	    @root_url ="http://#{@firm.subdomain}.lvh.me:31234/"
      @project.users << @user
      @log = FactoryGirl.create(:log, project: @project, user: @user, firm: @firm, begin_time: Time.now - 2.hours, end_time: Time.now,:log_date => Date.today.beginning_of_week)
      @log2 = FactoryGirl.create(:log, project: @project, user: @user, firm: @firm, begin_time: Time.now - 2.hours, end_time: Time.now,:log_date => Date.today.beginning_of_week + 1.day)
      Capybara.server_port = 31234 
      sub = @firm.subdomain
      Capybara.app_host = @root_url 
    end 
	end
	
	def sign_in_on_js
    visit @root_url
    find("#login_link").click
    fill_in "user_email2", :with => @user.email
    fill_in "user_password2", :with => "password"
    click_button "sign_in2"
    page.should have_content("Signed in successfully") 
	end

  def wait_for_ajax
    Timeout.timeout(Capybara.default_wait_time) do
      loop do
        active = page.evaluate_script('jQuery.active')
        break if active == 0
      end
    end
  end
end
 module Features
  module MailHelpers
 
    def last_email
      ActionMailer::Base.deliveries[0]
    end
 
    # Can be used like:
    #  extract_token_from_email(:reset_password)
    def extract_token_from_email(token_name)
      mail_body = last_email.body.to_s
      mail_body[/#{token_name.to_s}_token=([^"]+)/, 1]
    end
 
  end
end