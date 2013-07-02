require 'spec_helper'

describe TabsController do
	login_user
  
  before(:each) do
    @request.host = "#{@user.firm.subdomain}.example.com" 
    
  end
  describe "milestones" do
	 	let(:project)  	{FactoryGirl.create(:project)}
	 	let(:milestone)	{FactoryGirl.create(:milestone, project: project, firm: project.firm)}

	  it "should get milestones" do
	  	get :tabs_milestones, id: project.id, class: "Project", :format => 'js'
	  	assigns(:milestones).should == [milestone]
	  end
	end	
	describe "todos" do
	 	let(:project)  	{FactoryGirl.create(:project, firm: @user.firm)}
	 	let(:todo1)			{FactoryGirl.create(:todo, project: project, firm: @user.firm, user: @user, completed: false, due: Date.today)}
	 	let(:todo2)			{FactoryGirl.create(:todo, project: project, firm: @user.firm, user: @user, completed: true, due: Date.today)}

	  it "should get todos" do
	  	get :tabs_todos, id: project.id, class: "Project", :format => 'js'
	  	assigns(:not_done_todos).should == [todo1]
	  	assigns(:done_todos).should == [todo2]
	  	assigns(:members).should == [@user]
	  end
	end	
	describe "logs" do
	 	let(:project)  	{FactoryGirl.create(:project, firm: @user.firm)}
	 	let(:log)	{FactoryGirl.create(:log, project: project, firm: @user.firm, user: @user, log_date: Date.today)}

	  it "should get logs" do
	  	get :tabs_logs, id: project.id, class: "Project", :format => 'js'
	  	assigns(:logs).should == [log]
	  end
	end	
	describe "users" do
	 	let(:project)  	{FactoryGirl.create(:project, firm: @user.firm)}

	 	it "should get users" do
	  	project.users << @user
	  	get :tabs_users, id: project.id, class: "Project", :format => 'js'
	  	assigns(:users).should == [@user]
	  end
	end	
	describe "statistics" do
	 	let(:project)  	{FactoryGirl.create(:project, firm: @user.firm)}
	 	let(:log)	{FactoryGirl.create(:log, project: project, firm: @user.firm, user: @user, log_date: Date.today)}

	  it "should get statistics" do
	  	get :tabs_statistics, id: project.id, class: "Project", :format => 'js'
	  	assigns(:logs).should == [log]
	  end
	end	
	describe "statistics" do
	 	let(:project)  	{FactoryGirl.create(:project, firm: @user.firm)}
	 	let(:log)	{FactoryGirl.create(:log, project: project, firm: @user.firm, user: @user, log_date: Date.today)}

	  it "should get statistics" do
	  	project.users << @user
	  	get :tabs_spendings, id: project.id, class: "Project", :format => 'js'
	  	assigns(:logs).should == [log]
	  	assigns(:users).should == [@user]
	  end
	end	
end  