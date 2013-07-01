require 'spec_helper'

describe TimesheetsController do
	login_user
  
  before(:each) do
    @request.host = "#{@user.firm.subdomain}.example.com" 
  
  end
  describe "timesheet_day" do
  	let(:firm) 					{@user.firm}
  	let(:external_user) {FactoryGirl.create(:user, firm: firm, role: "External user")}
	  it "timesheet_week user admin" do
	  	firm.users << external_user
	  	get :timesheet_day, user_id: @user.id, date: Date.today
	  	assigns(:user).should == @user
	  	assigns(:users).should =~ [@user, external_user]
	  	assigns(:logs).should == @user.logs.where(:log_date => Date.today)
	  end
  end

  describe "timesheet_week different users" do
  	let(:firm) 					{@user.firm}
  	let(:external_user) {FactoryGirl.create(:user, firm: firm, role: "External user")}
	  it "timesheet_week user admin" do
	  	firm.users << external_user
	  	get :timesheet_week, user_id: @user.id
	  	assigns(:user).should == @user
	  	assigns(:users).should =~ [@user, external_user]
	  	assigns(:dates).should == ((Time.now.beginning_of_week.to_date)..(Time.now.end_of_week.to_date))
    	range = Time.zone.today..Time.zone.today + 7.days
    	assigns(:log_project).should == @user.logs.where(:log_date => @dates).group("project_id").sum(:hours)
    	assigns(:log_week).should == @user.logs.where(:log_date => @dates).group("date(log_date)").sum(:hours)
    	assigns(:log_week_project).should == @user.logs.where(:log_date => @dates).group("project_id").group("date(log_date)").sum(:hours)
    	assigns(:log_week_no_project).should == @user.logs.where(:log_date => @dates, :project_id => nil).group("date(log_date)").sum(:hours)
    	assigns(:projects).should == @user.projects
    	assigns(:log_total).should == @user.logs.where(:log_date => range).sum(:hours) 
	  end
  	it "timesheet_week user external_user" do
  		@user.role = "External user"
  		@user.save
	  	firm.users << external_user
	  	get :timesheet_week, user_id: @user.id
	  	assigns(:user).should == @user
	  	assigns(:users).should == []
	  end
  end
  describe "timesheet_month" do
  	let(:firm) 					{@user.firm}
  	let(:external_user) {FactoryGirl.create(:user, firm: firm, role: "External user")}
	  it "timesheet_week user admin" do
	  	firm.users << external_user
	  	get :timesheet_month, user_id: @user.id, date: Date.today
	  	assigns(:user).should == @user
	  	assigns(:users).should =~ [@user, external_user]
	  	assigns(:date).should == Date.today
	  	assigns(:logs_by_date).should == @user.logs.group("date(log_date)").sum(:hours)
    end
  end
  describe "adding logs to timesheet" do
  	let(:firm) {@user.firm}
  	let(:log)  {FactoryGirl.attributes_for(:log, end_time: Time.now + 2.hours, begin_time: Time.now, user_id: @user.id)}
  	it "should get the user" do
  		post :add_log_timesheet, log: log
  		assigns(:user).should == @user
  	end
  	it "should get the user" do
  		 expect{
          post :add_log_timesheet, log: FactoryGirl.attributes_for(:log, user_id: @user.id)
        }.to change(Log,:count).by(1)
  	end
  end
  describe "add_hour_to_project" do
  	let(:firm)     {@user.firm}
    let(:project)  {FactoryGirl.create(:project, firm: firm)}
    let(:log)      {FactoryGirl.create(:log, event: "old log", user: @user, project: project, firm: firm)}
    it "With empty field" do
  		post :add_hour_to_project, user_id: @user.id, project_id: project.id, date: Date.today, val_input: "3:34", :format => [:js]
  		assigns(:log).project.should == project
  	end
  	it "with already typed field" do
  		 post :add_hour_to_project, log_id: log.id, user_id: @user.id, project_id: project.id, date: Date.today, val_input: "3:34", :format => [:js]
      assigns(:log).project.should == project
      assigns(:log).event.should == "Added on timesheet"
  	end
  end
end