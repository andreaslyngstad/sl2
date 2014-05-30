require "spec_helper"

describe Milestone do
  it { should belong_to(:project) }
  it { should validate_presence_of(:goal) }
  let(:firm)      {FactoryGirl.create(:firm)}
  let(:project)   {FactoryGirl.create(:project, :firm => firm)}
  let(:user) 			{FactoryGirl.create(:user, :firm => firm)}
  let(:milestone1){FactoryGirl.create(:milestone, :due => Time.now - 1.day, :firm => firm,:project => project)}
  let(:milestone2){FactoryGirl.create(:milestone, :due => Time.now + 1.day, :firm => firm,:project => project)}
  let(:milestone3){FactoryGirl.create(:milestone, :due => Time.now + 15.days, :firm => firm,:project => project)}
  let(:milestone4){FactoryGirl.create(:milestone, :due => Time.now - 15.days, :firm => firm,:project => project)}
  it 'should be saved on correct firm' do
    firm2 = FactoryGirl.create(:firm)
    test = FactoryGirl.build(:milestone,:project => project, :firm => firm2)
    test.should_not be_valid
    test.errors[:base].should be_present
  end
  
 	it "has a passed date" do
    milestone1.overdue?.should == true
    milestone2.overdue?.should == false
  end
  it "Get milestones for user two weeks a head" do
  	project.users << user
  	Milestone.user_milestones_two_weeks(firm,user).should =~ [milestone1,milestone2]
    Milestone.user_milestones_two_weeks(firm,user).should_not include milestone3
  	Milestone.user_milestones_two_weeks(firm,user).should_not include milestone4
  end
  it "gets the next milestone" do 
    milestone1
    milestone2
    milestone3
    Milestone.next.first.should == milestone2
    Milestone.next.first.should_not == milestone3
    Milestone.next.first.should_not == milestone1
  end
end