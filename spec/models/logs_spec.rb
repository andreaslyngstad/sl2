require 'spec_helper'


describe Log do  
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
end