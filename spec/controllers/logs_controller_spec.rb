require 'spec_helper'

describe LogsController do 

  login_user
  
  before(:each) do
    @request.host = "#{@user.firm.subdomain}.example.com" 
  end
  
  describe "GET #index" do
    it "should have a current_user" do
      subject.current_user.should_not be_nil
      subject.current_firm.should_not be_nil
    end
    it "populates an array of logs" do
      log = FactoryGirl.create(:log, log_date: Time.now.to_date, :user => @user, :firm => @user.firm)
      get :index
      assigns(:logs).should == [log]   
    end
    it "renders the :index view" do
      get :index
      response.should render_template("index")
    end
  end 
   
  describe "GET edit" do
    it "should assign project to @project" do
      log = FactoryGirl.create(:log, :user => @user, :firm => @user.firm)
      get :edit, :id => log, :format => 'js'
      assigns(:log).should eq(log) 
    end 
  end
  describe "POST create" do
    context "with valid attributes" do
      it "creates a new log" do
        expect{
          post :create, log: FactoryGirl.attributes_for(:log), :format => 'js'
        }.to change(Log,:count).by(1)
      end
      
      it "gives flash notice when creating new log" do
        post :create, log: FactoryGirl.attributes_for(:log), :format => 'js'
        flash[:notice].should_not be_nil 
      end
    end 
  end
  describe 'PUT update' do
  before :each do
    @log = FactoryGirl.create(:log, user: @user, firm: @user.firm)
  end
  
  context "valid attributes" do
    
  
    it "changes @log's attributes" do
      put :update, id: @log, log: FactoryGirl.attributes_for(:log, :event => "something else"), :format => 'js'
      @log.reload
      @log.event.should eq("something else")
    end
  end
  
  
end
  describe 'DELETE destroy' do
    before :each do
      @log = FactoryGirl.create(:log, :user => @user,:firm => @user.firm)
    end
    
    it "deletes the contact" do
      expect{
        delete :destroy, id: @log , :format => 'js'       
      }.to change(Log,:count).by(-1)
    end
  end
  describe 'post start tracking' do
    it "creates a new log" do
        expect{
          post :start_tracking, log: FactoryGirl.attributes_for(:log), :format => 'js'
        }.to change(Log,:count).by(1)
      end
    it 'should get vaild repsonse' do 
    end
  end
  describe 'post stop tracking' do
    before :each do
      @log = FactoryGirl.create(:log, user: @user, firm: @user.firm)
    end
  
    context "valid attributes" do
      it "changes @log's attributes" do
        put :stop_tracking, id: @log, log: FactoryGirl.attributes_for(:log, :event => "something else"), :format => 'js'
        assigns(:log).should eq(@log)
        @log.reload
        @log.event.should eq("something else")
      end
    end
  end
  describe 'get_logs_todo' do
    it 'should assign todo to @todo' do  
      project = FactoryGirl.create(:project, firm: @user.firm)
      project.users << @user
      todo = FactoryGirl.create(:todo, user: @user, firm: @user.firm, project: project)
      log = FactoryGirl.create(:log, todo: todo, project: project, user: @user, firm: @user.firm)
      get :get_logs_todo, todo_id: todo, :format => 'js'
      assigns(:todo).should eq(todo)
    end
    it 'should send it off to LogWorker' do
    end
  end
end

