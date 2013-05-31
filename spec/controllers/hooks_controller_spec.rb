require 'spec_helper'


describe HooksController do
  
  let(:plan)          {FactoryGirl.create(:plan, name:"test", price: 99, paymill_id:"offer_b72bdb7a4539757ee843")}
  let(:firm)          {FactoryGirl.create(:firm, plan: plan)}
  describe "POST 'receiver'" do
    it "finds subscription and updates it", :vcr do
      @subscription = Subscription.new( firm: firm, plan: plan, name: "test", email: "test2@test.no", paymill_card_token: "098f6bcd4621d373cade4e832627b4f6") 
      @subscription.save_with_payment 
      @subscription.active = false
      @subscription.next_bill_on = DateTime.now.to_date
      @subscription.save
      event = {event: {event_type: "subscription.succeeded",event_resource: { subscription: @subscription.paymill_id,transaction: "Object"},created_at: "1358027174"}}
      request.env['RAW_POST_DATA'] = event.to_json  
      post 'receiver', event
      response.code.should eq("200")
      s = Subscription.find(@subscription.id)
      s.next_bill_on.should == (Time.at(Paymill::Subscription.find(@subscription.paymill_id).next_capture_at)).to_date 
      s.active.should == true
    end 
  end
end
