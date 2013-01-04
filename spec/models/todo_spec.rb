require "spec_helper"

describe Todo do
  it { should belong_to(:customer) }
  it { should belong_to(:project) }
  it { should belong_to(:user) }
  it { should belong_to(:firm) }
  it {should have_many(:logs)}
  
  it "Can be due to day" do
    todo = Todo.create!(:name => "Test", :due => Time.now, :completed => false, :firm => mock_model(Firm) )
    todo.due_to_day.should == true
  end
  it "Can be not due to day" do
    todo = Todo.create!(:name => "Test", :due => Time.now + 1.day, :completed => false, :firm => mock_model(Firm))
    todo.due_to_day.should == false
  end
  
  it "Can be overdue" do
    todo = Todo.create!(:name => "Test", :due => Time.now - 2.day, :completed => false, :firm => mock_model(Firm))
    todo.overdue.should == true
  end
  it "Can be not overdue" do
    todo = Todo.create!(:name => "Test", :due => Time.now + 1.day, :completed => false, :firm => mock_model(Firm))
    todo.overdue.should == false
  end
end