require 'spec_helper'
# let(:user) { create(:user) }
  # before { login_as user }
describe UsersController do 

  login_user
  
  before(:each) do
    @request.host = "#{@user.firm.subdomain}.example.com"
   
  end
  
  describe "GET #index" do
    it "should have a current_user" do
      subject.current_user.should_not be_nil
      subject.current_firm.should_not be_nil
    end
    it "populates an array of users" do
      @user = FactoryGirl.create(:user)
      get :index
      assigns(:users) == [@user]   
    end
    it "renders the :index view" do
      get :index
      response.should render_template("index")
    end
  end 
  
  describe "GET #show" do
    it "assigns the requested user to @user" do
      @user = FactoryGirl.create(:user)
      get :show, :id => @user
      assigns(:user) == [@user] 
    end
    it "renders the #show view" do
      @user = FactoryGirl.create(:user)
      get :show, :id => @user
      response.should render_template :show
    end
  end
  describe "POST create" do
    context "with valid attributes" do
      it "creates a new user" do
        expect{
          post :create, user: FactoryGirl.attributes_for(:user)
        }.to change(User,:count).by(1)
      end
      
      it "redirects to the new user" do
        post :create, user: FactoryGirl.attributes_for(:user)
        flash[:notice].should_not be_nil 
      end
    end 
  end
  describe 'PUT update' do
  before :each do
    @user = FactoryGirl.create(:user)
  end
  
  context "valid attributes" do
    it "located the requested @user" do
      put :update, id: @user, user: FactoryGirl.attributes_for(:user)
      assigns(:user).should eq(@klass)      
    end
  
    it "changes @user's attributes" do
      put :update, id: @user, user: FactoryGirl.attributes_for(:user, :name => "something else")
      @user.reload
      @user.name.should eq("something else")
    end
  end
  context "invalid attributes" do
    it "locates the requested @user" do
      put :update, id: @user, user: FactoryGirl.attributes_for(:user, :name => nil)
      assigns(:user).should eq(nil)      
    end
    
    it "does not change @user's attributes" do
      put :update, id: @user, 
        user: FactoryGirl.attributes_for(:user, :name => nil)
      @user.reload
      @user.name.should_not eq("something else")
    end
  end
  
end
  describe 'DELETE destroy' do
    before :each do
      @user = FactoryGirl.create(:user)
    end
    
    it "deletes the user" do
      expect{
        delete :destroy, id: @user        
      }.to change(User,:count).by(-1)
    end
      it "deletes the current_user" do
        @user = subject.current_user
      expect{
        delete :destroy, id: @user        
      }.to change(User,:count).by(0)
    end
    it "redirects to user#index" do
      delete :destroy, id: @user
      response.should redirect_to users_url
    end
  end
end