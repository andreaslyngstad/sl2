require 'spec_helper'

describe Subscription do
  
  it {should validate_presence_of(:plan_id) }
  it {should validate_presence_of(:firm_id) }
  let(:plan)          {FactoryGirl.create(:plan, name:"test", price: 99, paymill_id:"offer_b72bdb7a4539757ee843")}
  let(:firm)          {FactoryGirl.create(:firm, plan: plan)}
  let(:subscription)  {FactoryGirl.create(:subscription, plan: plan, firm: firm)}
  
  describe 'credit card info', :vcr do
    before do
      card = { number: '4111111111111111', exp_month: '11', exp_year: '2014' }
      
      @subscription = Subscription.new( firm: firm, plan: plan, name: "test", email: "test2@test.no", paymill_card_token: "098f6bcd4621d373cade4e832627b4f6") 
      @subscription.save_with_payment  
      # @paymill_subscription = Paymill::Subscription.find(@subscription.paymill_id)    
      # @customer    = Paymill::Client.find(@paymill_subscription.client["id"])   
      # @active_card = @customer.payment[0] 
  
    end
      
    subject { @subscription }
    its(:plan)                {should == plan}
    its(:name)                {should == "test"}   
    its(:paymill_id)          {should_not == nil}
    its(:paymill_id)          {should_not == ""}
    its(:last_four)           {should == "1111"}
    its(:active)              {should == true}
    # its(:next_bill_on)    { should == Date.parse(@customer.next_recurring_charge.date) }
    # its(:card_expiration) { should == "#{ @active_card.exp_month }-#{ @active_card.exp_year }" }
    # its(:paymill_card_token)  {should == card}
  end
  it "updates firms plan_id on save" do
    subscription.update_firm_plan 
    firm.plan.should == subscription.plan
  end
  it "deletes old subscription", :vcr do 
    subscription = Subscription.create( plan: plan, firm: firm) 
    Subscription.delete_old_subscription(subscription.firm)
    firm.subscription == nil
  end
end
describe "Webhooks" do
     
  before(:all) do
    @subscription = FactoryGirl.create(:subscription, paymill_id: "testtrue", active: true)
    @subscription1 = FactoryGirl.create(:subscription, paymill_id: "testfalse", active: false)
  end
  
  it "makes subscription inactive" do
    Subscription.make_inactive(@subscription1.paymill_id)
    @subscription1.active.should == false 
  end
    
  it "makes subscription active" do 
    Subscription.make_active(@subscription1.paymill_id)
    @subscription.active.should == true 
  end
end


