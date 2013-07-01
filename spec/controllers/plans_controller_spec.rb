require 'spec_helper'

describe PlansController do
login_user
   
  before(:each) do
    @request.host = "#{@user.firm.subdomain}.example.com"  
  end
  
  describe "GET 'new'" do
    it "should have a current_user" do
      subject.current_user.should_not be_nil
      subject.current_firm.should_not be_nil
    end
    
    it "returns http success" do
      get 'index'
      response.should be_success
    end
    it "returns http success" do
      plan = Plan.where(name:"Free").first
      plan1 = FactoryGirl.create(:plan, price: 1)
      plan2 = FactoryGirl.create(:plan, price: 2)
      get :index
      assigns(:plans).should eq([plan, plan1, plan2, @user.firm.plan])
    end
  end
  describe "get canel" do
    it "returns http success" do
      get :cancel
      response.should be_success
    end
    it "should find the current plan" do
      get :cancel
      assigns(:plan).should eq(subject.current_firm.plan)
    end
  end

end
