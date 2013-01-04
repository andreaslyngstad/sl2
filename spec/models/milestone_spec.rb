require "spec_helper"

describe Milestone do
  it { should belong_to(:project) }
  it { should validate_presence_of(:goal) }
  
  it "has a passed date" do
    milestone = Milestone.create!(:goal => "test", :due => Time.now - 1.day, :firm => mock_model(Firm))
    milestone.overdue?.should == true
    milestone = Milestone.create!(:goal => "test", :due => Time.now + 1.day, :firm => mock_model(Firm))
    milestone.overdue?.should == false
  end
end