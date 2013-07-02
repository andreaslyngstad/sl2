require 'spec_helper'


describe Log do  
  
  it { should belong_to(:user) }
  it { should belong_to(:customer) }
  it { should belong_to(:firm) }
  it { should belong_to(:project) }
  it { should belong_to(:todo) }
  it { should belong_to(:employee) }  
  let(:firm)      {FactoryGirl.create(:firm)}
  let(:user)      {FactoryGirl.create(:user, :firm => firm)}
  let(:time_now)  {Time.now}
  let(:log)       {FactoryGirl.create(:log, :user => user, :firm => firm)}
  let(:log2)      {FactoryGirl.create(:log, :log_date => Date.today.beginning_of_week + 1.day, :begin_time => time_now, :end_time => time_now + 1.hours, :user => user, :firm => firm)}
  let(:log3)      {FactoryGirl.create(:log, :log_date => Date.today.beginning_of_week - 1.day, :begin_time => time_now, :end_time => time_now + 1.hours, :user => user, :firm => firm)}
  let(:project)   {FactoryGirl.create(:project, :firm => firm)}
  let(:range)     {Date.today.beginning_of_week..Date.today.end_of_week}
  # it 'Displays the total time' do
  #   log = FactoryGirl.create(:log, :begin_time => time_now, :end_time => time_now + 30.hours, :user => user, :firm => firm)
  #   assert_equal '30:00', log.total_time
  #   log = FactoryGirl.create(:log,:begin_time => time_now, :end_time => time_now + 3.hours, :user => user, :firm => firm)
  #   assert_equal '3:00', log.total_time 
  #   log = FactoryGirl.create(:log,:begin_time => time_now, :end_time => time_now + 3.minutes, :user => user, :firm => firm)
  #   assert_equal '0:03', log.total_time 
  #   log = FactoryGirl.create(:log,:begin_time => time_now, :end_time => time_now + 13.minutes, :user => user, :firm => firm)
  #   assert_equal '0:13', log.total_time 
  # end
  it 'does check plan limit' do
    plan = FactoryGirl.create(:plan, logs: 1 )
    firm.plan = plan
    firm.logs_count = 30
    FactoryGirl.build(:log, :begin_time => time_now, :end_time => time_now + 30.hours, :user => user, :firm => firm).should_not be_valid
  end
  it 'should be saved on correct firm' do
    firm2 = FactoryGirl.create(:firm)
    FactoryGirl.build(:log, :begin_time => time_now, :end_time => time_now + 30.hours, :user => user, :firm => firm2).should_not be_valid
  end
  it 'should demand project for external users' do
    user = FactoryGirl.create(:user, :firm => firm, role: 'External user')
    FactoryGirl.build(:log, :project => nil, :firm => firm, :user => user).should_not be_valid
  end
  it 'Should set hour spent in right format before save' do 
    log.hours.should == log.end_time - log.begin_time
  end
  # it 'Has a total_time' do
  #   time = time_now
  #   log = Log.create!(:event => 'test', :begin_time => time, :end_time => time + 3.hours, :user => user, :firm => firm)
  #   log.total_time.should == '3:00'
  # end

  it 'should have time' do
    log = FactoryGirl.create(:log,:begin_time => time_now, :end_time => time_now + 3.hours, :user => user, :firm => firm)
    assert_equal 10800.0, log.time
  end
  it 'should_not save when end is before start' do
    FactoryGirl.build(:log, :begin_time =>  time_now + 30.hours, :end_time => time_now, :user => user, :firm => firm).should_not be_valid
  end
  
  it 'should calculate hours for timesheet' do
     log2
     log3
     Log.logs_for_timesheet(user).should == {[nil, (Date.today.beginning_of_week + 1.day)]=>3600.0}
  end
  
  it 'should find hours by day and model' do
    log2
    log3
    model = :user
    logs = Log.hours_by_day_and_model(firm, range, model)
    logs.each do |l|
      l.total_hours.should == 3600.0
      l.user.should == user
      l.log_date.should == Date.today.beginning_of_week + 1.day
    end
  end
  it 'should get hours by model' do
    log2
    log3
    model = :user
    logs = Log.hours_by_model(firm, range, model)
    logs.each do |l|
      l.total_hours.should == 3600.0
      l.user.should == user
    end
  end
  it 'should find inbetween' do
    log2.placed_between?(range).should == true
    log3.placed_between?(range).should == false
  end
  it 'should find logs' do
    log4 = FactoryGirl.create(:log, :user => user, :firm => firm, :project => project)
    log5 = FactoryGirl.create(:log, :user => user, :firm => firm, :project => project)
    Log.try_find_logs(user_id: user.id,project_id: project.id).should =~ [log4,log5]
    Log.try_find_logs(user_id: user.id,project_id: project.id).should_not == [log]
  end
end