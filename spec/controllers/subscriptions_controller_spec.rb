require 'spec_helper'

describe SubscriptionsController do
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
      @plan = FactoryGirl.create(:plan, paymill_id: "bull" )
      get 'new', plan_id: @plan.id.to_s
      response.should be_success
    end 
  end

  describe "POST create", :vcr do
    let(:subscription) { mock_model(Subscription).as_null_object }

    before do
      Subscription.stub(:new).and_return(subscription)
    end

    it "creates a new message" do
      Subscription.should_receive(:new).
        with("text" => "a quick brown fox").
        and_return(subscription)
      post :create, :subscription => { "text" => "a quick brown fox" }
    end

    it "saves the message" do
      subscription.should_receive(:save_with_payment)
      post :create
    end

    it "redirects to the Messages index" do
       post :create
      response.should redirect_to(:controller => "plans", :action => "index")
    end
  end
end


