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

  
  let(:f)               {FactoryGirl.create(:firm)}
  let(:f2)              {FactoryGirl.create(:firm)}
  let(:p)               {FactoryGirl.create(:plan, name: "costly", price: 1200)}
  let(:p1)              {FactoryGirl.create(:plan, name: "cheep", price: 12)}
  let(:customer_list)   {FactoryGirl.create_list(:customer,20, firm: f)}
  let(:user_list)       {FactoryGirl.create_list(:user,20, firm: f)}
  let(:project_list)    {FactoryGirl.create_list(:project,20, firm: f)}
 
  it "should be created with a plan" do
    f.subscription.should_not == nil 
    f.plan.name == "Free" 
  end
  
  it "should update firm_plan" do 
   f.update_plan(f.subscription.plan_id)
   f.plan.name == "Free"  
  end 
  
  it "should update counters" do 
    customer_list
    user_list
    project_list
    f.update_firm_counters
    f.customers_count.should == 20
    f.projects_count.should == 20
    f.users_count.should == 20
  end
  
  it "should remove associations when downgrading" do
    customer_list
    user_list
    project_list
    f.update_firm_counters
    p2 = Plan.where(name: "Free").first
    f.remove_associations_when_downgrading(p2.id) 
    f.customers.count.should == 2
    f.projects_count.should == 2
    f.users_count.should == 2
  end
  
  it "should check payment" do
    f.subscription = FactoryGirl.create(:subscription, active: true, next_bill_on: Time.now.to_date - 1.day )
    f2.subscription = FactoryGirl.create(:subscription, active: true,  next_bill_on: Time.now.to_date + 1.days)
    f.payment_check?.should == true
    f2.payment_check?.should == false
  end  
  
  it "closes down" do
    f.close!
    f.closed.should == true
  end 
  it "opens up" do
    f.open!
    f.closed.should == false
  end 
  
  it "reverts to free plan" do  
    f.subscription = FactoryGirl.create(:subscription, paymill_id: "test", plan: p)
    customer_list
    user_list 
    project_list
    f.update_firm_counters
    f.users.count.should == 20
    f.subscription.plan.name.should == "costly" 
    f.revert_to_free_no_payment 
    f.subscription.plan.name.should == "Free" 
    f.subscription.plan.customers.should == 2
    f.subscription.plan.users.should == 2
    f.subscription.plan.projects.should == 2
    f.users.count.should == 2 
    f.users_count.should == 2 
  end
  it "generates a hash of firms per subscription" do
    # Plan.destroy_all
    # f
    # Firm.count_by_plan.should == {Plan.last => 1}
  end
end