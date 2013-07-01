require 'spec_helper'

describe TimerangeController do
	login_user
  
  before(:each) do
    @request.host = "#{@user.firm.subdomain}.example.com" 
    
  end
  describe "logs" do
	 	let(:project)  	{FactoryGirl.create(:project, firm: @user.firm)}
	 	let(:customer)	{FactoryGirl.create(:customer, firm: @user.firm)}
		let(:range)   	{Date.today - 5.days..Date.today}
		let(:log)	{FactoryGirl.create(:log, project: project, firm: @user.firm, user: @user, log_date: Date.today)}

	  it "log_range" do
	  	project.users << @user
	  	get :log_range, from:Date.today - 5.days, to:Date.today, url: "Project", id: project.id
	  	assigns(:customers).should == [customer]
	  	assigns(:all_projects).should == [project]
	  	assigns(:logs).should == [log]
	  end
	  it "log_range" do
	  	project.users << @user
	  	get :log_range, time: "to_day", url: "Project", id: project.id
	  	assigns(:customers).should == [customer]
	  	assigns(:all_projects).should == [project]
	  	assigns(:logs).should == [log]
	  end
	end	
	describe "todos" do
	 	let(:project)  	{FactoryGirl.create(:project, firm: @user.firm)}
	 	let(:customer)	{FactoryGirl.create(:customer, firm: @user.firm)}
		let(:range)   	{Date.today - 5.days..Date.today}
	 	let(:todo1)			{FactoryGirl.create(:todo, project: project, firm: @user.firm, user: @user, completed: true, due: Date.today)}
	 	let(:todo2)			{FactoryGirl.create(:todo, project: project, firm: @user.firm, user: @user, completed: false, due: Date.today)}

	  it "todo_range" do
	  	project.users << @user
	  	get :todo_range,{from:Date.today - 5.days, to:Date.today, url: "Project", id: project.id , :format => [:js]}
	  	assigns(:klass).should == project
	  	assigns(:done_todos).should == [todo1]
	  	assigns(:not_done_todos).should == [todo2]
	  end
	  it "todo_range" do
	  	project.users << @user
	  	get :todo_range, time: "to_day", url: "Project", id: project.id, :format => [:js]
	  	assigns(:klass).should == project
	  	assigns(:done_todos).should == [todo1]
	  	assigns(:not_done_todos).should == [todo2]
	  end
	end	

end