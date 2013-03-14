require "spec_helper"

describe Project do
  it {should have_many(:logs)}
  it {should have_many(:todos)}
  it {should have_many(:milestones)}
  it {should have_many(:users)}
  it {should belong_to(:customer) }
  it {should belong_to(:firm) }
  
  
  let(:plan)    {FactoryGirl.create(:plan, projects: 50)}
  
  let(:firm)    {FactoryGirl.create(:firm, projects_count: 51, plan: plan)}
  let(:firm1)    {FactoryGirl.create(:firm, projects_count: 50, plan: plan)}
  
  it "should not save if over plan limit" do
    FactoryGirl.build(:project, firm_id: firm.id).should_not be_valid
  end
  it "should validate_presence_of name" do
    FactoryGirl.build(:project, firm_id: firm1.id, name: "").should_not be_valid
  end
end
