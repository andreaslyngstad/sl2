require "spec_helper"

describe Project do
  it {should have_many(:logs)}
  it {should have_many(:todos)}
  it {should have_many(:milestones)}
  it {should have_many(:users)}
  it {should belong_to(:customer) }
  it {should belong_to(:firm) }
  
  
  let(:plan)      {FactoryGirl.create(:plan, projects: 50)}
  let(:firm)      {FactoryGirl.create(:firm, projects_count: 51, plan: plan)}
  let(:firm1)     {FactoryGirl.create(:firm, projects_count: 0, plan: plan)}
  let(:customer)  {FactoryGirl.create(:customer, firm: firm)}
  
  it "should not save if over plan limit"  do
    FactoryGirl.build(:project, firm_id: firm.id).should_not be_valid
  end
  it "should validate_presence_of name" do
    project = FactoryGirl.build(:project, firm_id: firm1.id, name: "")
    project.should_not be_valid
    project.errors[:name].should be_present
  end
  it 'should not save on different firm' do
    test = FactoryGirl.build(:project, customer: customer,firm_id: firm1.id)
    test.should_not be_valid
    test.errors[:firm_id].should be_present
  end
end
