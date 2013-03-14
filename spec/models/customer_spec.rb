require "spec_helper"

describe Customer do
   it {should have_many(:logs)}
   it {should have_many(:projects)}
   it {should have_many(:employees)}
   it { should belong_to(:firm) }  
   
   
  let(:plan)    {FactoryGirl.create(:plan, customers: 50)} 
  let(:firm)    {FactoryGirl.create(:firm, customers_count: 51, plan: plan)}
  let(:firm1)   {FactoryGirl.create(:firm, customers_count: 50, plan: plan)}
  
  it "should not save if over plan limit" do
    FactoryGirl.build(:customer, firm_id: firm.id).should_not be_valid
  end
  it "should validate_presence_of name" do
    FactoryGirl.build(:customer, firm_id: firm1.id, name: "").should_not be_valid
  end
end