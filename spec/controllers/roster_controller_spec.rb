require 'spec_helper'
describe RosterController do 
  login_user
  before(:each) do
    @request.host = "#{ @user.firm.subdomain}.example.com"
    @project = FactoryGirl.create(:project, :firm => @user.firm)
    @project.users << @user
  end

  describe "GET milestones" do
	  it "populates an array of milestones" do 
	  	milestone1 = FactoryGirl.create(:milestone, :due => Time.now - 1.day, :firm => @user.firm,:project => @project)
			milestone2 = FactoryGirl.create(:milestone, :due => Time.now + 1.day, :firm => @user.firm,:project => @project)
			milestone3 = FactoryGirl.create(:milestone, :due => Time.now + 15.days, :firm => @user.firm,:project => @project)
	    get :get_milestones
	    assigns(:milestones).should eq([milestone1,milestone2])
	    assigns(:milestones).should_not include (milestone3)
	  end 
  end 
  describe "get tasks" do
    it "assigns the requested get tasks to @tasks_overdue_and_to_day" do
    	todo1 = FactoryGirl.create(:todo, user: @user, firm: @user.firm, project: @project, due: Time.now.to_date, completed: false )  
      todo2 = FactoryGirl.create(:todo, user: @user, firm: @user.firm, project: @project, due: Time.now.to_date + 1.day, completed: false )  
      get :get_tasks
      assigns(:tasks_overdue_and_to_day).should eq([todo1])
      assigns(:tasks_overdue_and_to_day).should_not include (todo2)
    end
  end
end