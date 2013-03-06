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

  
  before(:each) do
   @firm = FactoryGirl.create(:firm) 
  end

  it "should be created with a plan" do
    @firm = FactoryGirl.create(:firm) 
    #firm.send(:add_free_subscription)
    @firm.subscription.should_not == nil 
  end
  
  it "should update firm_plan" do 
   @firm.update_plan(@firm.subscription.plan_id)
   @firm.plan_id.should == 1  
  end 
end