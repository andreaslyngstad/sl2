require "spec_helper"

describe Firm do
   it {should have_many(:logs)}
   it {should have_many(:todos)}
   it {should have_many(:customers)}
   it {should have_many(:users)}
   it {should have_many(:projects)}
   it {should_not allow_value("#_").for(:subdomain) }
   it {should allow_value("test").for(:subdomain) }
   it {should validate_uniqueness_of(:subdomain) }
   it {should validate_presence_of(:subdomain) }
   it {should validate_presence_of(:name) }

  it "should be created with a plan" do
    firm = Firm.new
    firm.add_free_subscription
    firm.plan_id.should == 1
  end
  
  it "should updateexit_plan" do 
   firm = Firm.create!(:subdomain=>"ersr",:name=>"we")
   sub = mock_model Subscription, :plan_id => 6
   firm.update_plan(sub)
   firm.plan_id.should == 6
  end 
end