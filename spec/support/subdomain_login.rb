module SubdomainLogin
  def login_at_subdomain
    let(:firm)        {FactoryGirl.create(:firm)}
    let(:user)        {FactoryGirl.create(:user, firm: firm)}
    
    let(:project)     {FactoryGirl.create(:project, firm: firm, active: true, name: "test_project")}  
    before(:all) do
      project.users << user
      @driver = Selenium::WebDriver.for :firefox
      @base_url = "http://#{firm.subdomain}.lvh.me:3001"   
      @driver.get(@base_url + "/")
      @accept_next_alert = true
      @driver.manage.timeouts.implicit_wait = 30
      @verification_errors = []
      @driver.find_element(:id, "user_email").send_keys user.email
      @driver.find_element(:id, "user_password").send_keys user.password 
      @driver.find_element(:name, "commit").click 
      @driver.find_element(:css, "BODY").text.should =~ /^[\s\S]*Signed in[\s\S]*$/
    end
  
    # after(:each) do
      # @driver.quit
      # @verification_errors.should == []
    # end
  end
end