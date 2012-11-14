require 'spec_helper'


describe PublicController do 
  describe "registration frim" do
    it "Shows form for new firm" do
      get :register
      response.should render_template("register")
    end
  end
  
  describe "registration save frim" do
    describe "success" do
      it "Saves firm and goes to first user registration" do
        @firm = FactoryGirl.attributes_for(:firm, :name => "Firm", :subdomain => "test")
        post :create_firm, :firm => @firm
        @firm = Firm.last
        @firm.name.should  == "Firm"
        @firm.subdomain.should == "test"
        response.should redirect_to(register_user_path(@firm))
      end
    describe "failure" do
      it "Does not save firm without name" do
        @firm = FactoryGirl.attributes_for(:firm, :name => "", :subdomain => "test")
        post :create_firm, :firm => @firm
        flash[:error].should_not be_nil 
        response.should render_template("register")
      end
      it "Does not save firm without subdomain" do
        @firm = FactoryGirl.attributes_for(:firm, :name => "firm", :subdomain => "")
        post :create_firm, :firm => @firm
        flash[:error].should_not be_nil 
        response.should render_template("register")
      end
      it "Does not save firm with faulty subdomain" do
        @firm = FactoryGirl.attributes_for(:firm, :name => "firm", :subdomain => "[:_")
        post :create_firm, :firm => @firm
        flash[:error].should_not be_nil
        response.should render_template("register") 
      end
    end
    end
  end
  describe "registration of first user in firm" do
    before(:each) do
      
    end
    it "Shows form for new firm" do
      @firm = FactoryGirl.create(:firm, :name => "Firm", :subdomain => "subdomain")
      get :first_user, :firm_id => @firm.id.to_s
      response.should render_template("first_user")
    end
  end
  describe "registration save first user" do
    before(:each) do
      @firm = FactoryGirl.create(:firm, :name => "Firm", :subdomain => "subdomain")
    end   
    describe "success" do
      it "Saves user and gets redirected to application" do
        @user = FactoryGirl.attributes_for(:user, :name => "user", :email => "user@firm.com", :password => "secret")
        post :create_first_user, :firm_id => @firm.id.to_s, :user => @user
        @user = User.last
        @user.name.should  == "user"
        @user.email.should == "user@firm.com"
       
        #response.should redirect_to(after_sign_in_path_for(@user))
      end
    describe "failure" do
      it "Does not save user without name" do
        @user = FactoryGirl.attributes_for(:user, :name => "", :email => "user@firm.com", :password => "secret")
        post :create_first_user, :firm_id => @firm.id.to_s, :user => @user
        flash[:error].should_not be_nil 
        response.should render_template("first_user")
      end
      it "Does not save user without email" do
        @user = FactoryGirl.attributes_for(:user, :name => "user", :email => "", :password => "secret")
        post :create_first_user, :firm_id => @firm.id.to_s, :user => @user
        flash[:error].should_not be_nil 
        response.should render_template("first_user")
      end
      it "Does not save user with faulty email" do
        @user = FactoryGirl.attributes_for(:user, :name => "user", :email => "blah", :password => "secret")
        post :create_first_user, :firm_id => @firm.id.to_s, :user => @user
        flash[:error].should_not be_nil
        response.should render_template("first_user") 
      end
      it "Does not save user without password" do
        @user = FactoryGirl.attributes_for(:user, :name => "user", :email => "blah", :password => "")
        post :create_first_user, :firm_id => @firm.id.to_s, :user => @user
        flash[:error].should_not be_nil
        response.should render_template("first_user") 
      end
      end
     end
    end
end