require 'spec_helper'


describe HooksController do
  
  let(:plan)          {FactoryGirl.create(:plan, name:"test", price: 99, paymill_id:"offer_dbe27a284b10c57ba23e")}
  let(:firm)          {FactoryGirl.create(:firm, plan: plan)}
  describe "POST 'receiver'" do
    it "finds subscription and updates it", :vcr do
      @subscription = Subscription.new( card_holder: "card_holder_test", firm: firm, plan: plan, name: "test", email: "test2@test.no", paymill_card_token: "098f6bcd4621d373cade4e832627b4f6") 
      @subscription.save_with_payment 
      @subscription.active = false
      @subscription.next_bill_on = DateTime.now.to_date
      @subscription.save

      event = {event: {event_type: "subscription.succeeded",event_resource: { subscription: @subscription.paymill_id,transaction: "Object"},created_at: "1358027174"}}
      request.env['RAW_POST_DATA'] = event.to_json  
      post 'receiver', event 
      response.code.should eq("200") 
     
      s = Subscription.find(@subscription.id)
      # s.card_holder.should == "card_holder_test"  
      firm.payments.where(amount: 99,  
                          plan_name: s.plan.name, 
                          card_type: s.card_type,
                          last_four: s.last_four).count.should == 2
      s.next_bill_on.should == (Time.at(Paymill::Subscription.find(@subscription.paymill_id).next_capture_at)).to_date 
      s.active.should == true
    end  
    it "does not get payment and does not set subscription to active", :vcr do
      @subscription = Subscription.new( firm: firm, plan: plan, name: "test", email: "test2@test.no", paymill_card_token: "098f6bcd4621d373cade4e832627b4f6") 
      @subscription.save_with_payment 
      @subscription.active = false
      @subscription.next_bill_on = DateTime.now.to_date
      @subscription.save
      event = {event: {event_type: "subscription.failed",event_resource: { subscription: @subscription.paymill_id,transaction: "Object"},created_at: "1358027174"}}
      request.env['RAW_POST_DATA'] = event.to_json  
      post 'receiver', event
      response.code.should eq("200")
      s = Subscription.find(@subscription.id)
      # s.next_bill_on.should == (Time.at(Paymill::Subscription.find(@subscription.paymill_id).next_capture_at)).to_date 
      s.active.should == false
    end
  end
end