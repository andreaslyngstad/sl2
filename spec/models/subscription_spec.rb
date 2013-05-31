require 'spec_helper'

describe Subscription do
  
  it {should validate_presence_of(:plan_id) }
  it {should validate_presence_of(:firm_id) }
  let(:plan)          {FactoryGirl.create(:plan, name:"test2", price: 99, paymill_id:"offer_b72bdb7a4539757ee843")}
  let(:firm)          {FactoryGirl.create(:firm, plan: plan)}
  let(:subscription)  {FactoryGirl.create(:subscription, plan: plan, firm: firm)}
  
  describe 'credit card info', :vcr do
    before do
      card = { number: '4111111111111111', exp_month: '11', exp_year: '2014' }
      @subscription = Subscription.new( firm: firm, plan: plan, name: "test", email: "test2@test.no", paymill_card_token: "098f6bcd4621d373cade4e832627b4f6") 
      @subscription.save_with_payment  
      
    end

    subject { @subscription }
    
    its(:plan)                {should == plan}
    its(:name)                {should == "test"}   
    its(:paymill_id)          {should_not == nil}
    its(:paymill_id)          {should_not == ""}
    its(:last_four)           {should == "1111"}
    its(:active)              {should == true}
    its(:next_bill_on)        {should == (Time.at(Paymill::Subscription.find(@subscription.paymill_id).next_capture_at)).to_date }
    its("firm.closed")        {should == false }
    
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
describe "cron job for checking payment" do
  
    let(:f) { FactoryGirl.create(:firm, created_at: Time.now - 40.days, closed: false) }
    let(:p) { FactoryGirl.create(:plan, name: "costly", price: 1200) }
    let(:p1) { FactoryGirl.create(:plan, name: "Free", price: 0) }
    let(:s1) { FactoryGirl.create(:subscription, email: "s1@s1.com", firm_id: f.id, plan_id: p.id, next_bill_on: Time.now.to_date - 1.days )}
    let(:s2) { FactoryGirl.create(:subscription, email: "s2@s2.com", firm_id: f.id, plan_id: p.id, next_bill_on: Time.now.to_date)}
    let(:s3) { FactoryGirl.create(:subscription, email: "s3@s3.com", firm_id: f.id, plan_id: p.id, next_bill_on: Time.now.to_date + 1.days )}
    let(:s4) { FactoryGirl.create(:subscription, email: "s3@s3.com", firm_id: f.id, plan_id: p.id, next_bill_on: Time.now.to_date - 14.days )}
    let(:s5) { FactoryGirl.create(:subscription, email: "s3@s3.com", firm_id: f.id, plan_id: p.id, next_bill_on: Time.now.to_date - 1.month )}
    
 it "should check for unpaid subscriptions" do 
    s1
    s2
    s3
    Subscription.set_not_paid_not_active
    Subscription.find(s1.id).active.should == false
    Subscription.find(s2.id).active.should == true
    Subscription.find(s3.id).active.should == true
  end 
  
 it "should send email to expired subscriptions and close the firm down" do
    s1
    s2
    s3
    Subscription.send_email_to_expired_subscriptions
    last_email.to.should include(s1.email)
    Firm.find(f.id).closed.should == true
   
 end 
 
 it "sends mail on two weeks overdue" do
    s1 
    s2 
    s3
    s4
    s5
    Subscription.send_email_two_weeks_overdue
    last_email.to.should include(s4.email)
    Firm.find(f.id).closed.should == true
 end
 
 it "sends mail after reverting to free at one month overdue" do
    s1 
    s2 
    s3
    s4
    s5
    Subscription.one_month_overdue
    last_email.to.should include(s5.email)
    Firm.find(f.id).closed.should == true
    # Firm.find(f.id).subscription.plan.name.should == "Free"
 end
 
 
 it "reverts to free when it's one month overdue" do
   
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


