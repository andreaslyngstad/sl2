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
      @log = FactoryGirl.create(:log)
      get :index
      assigns(:logs) == [@log]   
    end
    it "renders the :index view" do
      get :index
      response.should render_template("index")
    end
  end 
  
 
  describe "POST create" do
    context "with valid attributes" do
      it "creates a new log" do
        expect{
          post :create, log: FactoryGirl.attributes_for(:log)
        }.to change(Log,:count).by(1)
      end
      
      it "gives flash notice when creating new log" do
        post :create, log: FactoryGirl.attributes_for(:log)
        flash[:notice].should_not be_nil 
      end
    end 
  end
  describe 'PUT update' do
  before :each do
    @log = FactoryGirl.create(:log, :firm => @user.firm)
  end
  
  context "valid attributes" do
    it "located the requested @contact" do
      put :update, id: @log, log: FactoryGirl.attributes_for(:log)
      assigns(:log).should eq(@log)      
    end
  
    it "changes @log's attributes" do
      put :update, id: @log, log: FactoryGirl.attributes_for(:log, :event => "something else")
      @log.reload
      @log.event.should eq("something else")
    end
  end
  context "invalid attributes" do
    it "locates the requested @log" do
      put :update, id: @log, log: FactoryGirl.attributes_for(:log, :event => nil)
      assigns(:log).should eq(@log)      
    end
    
    it "does not change @log's attributes" do
      put :update, id: @log, 
        log: FactoryGirl.attributes_for(:log, :event => nil)
      @log.reload
      @log.event.should_not eq("something else")
    end
  end
  
end
  describe 'DELETE destroy' do
    before :each do
      @log = FactoryGirl.create(:log, :firm => @user.firm)
    end
    
    it "deletes the contact" do
      expect{
        delete :destroy, id: @log        
      }.to change(Log,:count).by(-1)
    end
      
    it "redirects to contacts#index" do
      delete :destroy, id: @log
      response.should redirect_to logs_url
    end
  end
end

