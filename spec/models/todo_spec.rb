require "spec_helper"

describe Todo do
  let(:firm)    {FactoryGirl.create(:firm)}
  let(:project) {FactoryGirl.create(:project, firm: firm)}
  let(:user)    {FactoryGirl.create(:user, firm: firm)}
  it { should belong_to(:customer) }
  it { should belong_to(:project) }
  it { should belong_to(:user) }
  it { should belong_to(:firm) }
  it {should have_many(:logs)}
  
  it "Can be due to day" do
    todo = Todo.create!(:name => "Test", :due => Time.now, :completed => false, :firm => firm, :project => project, :user => user)
    todo.due_to_day.should == true
  end
  it "Can be not due to day" do
    todo = Todo.create!(:name => "Test", :due => Time.now + 1.day, :completed => false, :firm => firm, :project => project, :user => user)
    todo.due_to_day.should == false
  end
  
  it "Can be overdue" do
    todo = Todo.create!(:name => "Test", :due => Time.now - 2.day, :completed => false, :firm => firm, :project => project, :user => user)
    todo.overdue.should == true
  end
  it "Can be not overdue" do
    todo = Todo.create!(:name => "Test", :due => Time.now + 1.day, :completed => false, :firm => firm, :project => project, :user => user)
    todo.overdue.should == false
  end
  it "should not save without user" do
    FactoryGirl.build(:todo, :name => "Test", :due => Time.now + 1.day, :firm => firm, :project => project).should_not be_valid 
  end
  it "should not save without project" do
    FactoryGirl.build(:todo, :name => "Test", :due => Time.now + 1.day, :firm => firm, :user => user).should_not be_valid 
  end
end