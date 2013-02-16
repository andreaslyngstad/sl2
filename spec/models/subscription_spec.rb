require 'spec_helper'

describe Subscription do
  it {should validate_presence_of(:plan_id) }
  it {should validate_presence_of(:firm_id) }
  
  it "saves with payment" do
    
    expect{Subscription.new.save_with_payment}.to raise_error(Paymill::PaymillError)
    
  end
  it "deletes old subscription" do
    
    firm = FactoryGirl.create(:firm )
    sub = FactoryGirl.create(:subscription, :firm_id => firm.id ) 
    expect{Subscription.delete_old_subscription(sub.firm_id)}.to change(Subscription,:count).to(0)
    
  end

end


