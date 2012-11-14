require 'spec_helper'


describe Log do  
  
  it { should belong_to(:user) }
  it { should belong_to(:customer) }
  it { should belong_to(:firm) }
  it { should belong_to(:project) }
  it { should belong_to(:todo) }
  it { should belong_to(:employee) }
  
  it "Displays the total time" do
    log = Log.create!(:begin_time => Time.now, :end_time => Time.now + 30.hours)
    assert_equal "30:00", log.total_time
    log = Log.create!(:begin_time => Time.now, :end_time => Time.now + 3.hours)
    assert_equal "3:00", log.total_time 
    log = Log.create!(:begin_time => Time.now, :end_time => Time.now + 3.minutes)
    assert_equal "0:03", log.total_time 
    log = Log.create!(:begin_time => Time.now, :end_time => Time.now + 13.minutes)
    assert_equal "0:13", log.total_time 
   end
  it "Should set hour spent in right format before save" do
    time = Time.now
    log = Log.create!(:event => "test", :begin_time => time, :end_time => time + 3.hours)
    log.hours.should == log.end_time - log.begin_time
  end
  
  it "Should not allow end_time before begin_time" do
    time = Time.now
    lambda {Log.create!(:event => "test", :begin_time => time, :end_time => time - 3.hours)}.should raise_error
  end
  it "Has a total_time" do
    time = Time.now
    log = Log.create!(:event => "test", :begin_time => time, :end_time => time + 3.hours)
    log.total_time.should == "3:00"
  end
end