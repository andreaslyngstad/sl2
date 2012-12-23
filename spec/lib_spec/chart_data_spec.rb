require "date"
require 'support/active_record'
require File.expand_path(File.dirname(__FILE__) + "../../../app/models/log.rb")

require "./lib/chart_data.rb"

describe ChartData do
  it "returns the stacked JSON" do
    firm  = stub(:name)
    user1 = stub(:name) 
    user2 = User.new("test_user2",  1, 1) 
    log1 = Log.new(:event =>"test", :log_date => Date.new(2012,12,17), :firm_id => 1, :user_id => 1, :hours => 3600)
    log2 = Log.new(:event =>"test", :log_date => Date.new(2012,12,22), :firm_id => 1, :user_id => 2, :hours => 3600)
    logs = [log1,log2]
    
    ChartData.new(firm,Date.new(2012,12,17)..Date.new(2012,12,21),:user).
    should == 0
  end
  describe "logs_by_day" do
    it "returns the a hash of log dates and log hours"
  end
  
  describe "chart_data" do
    it "returns the log hours on each date"
  end
end
class User < Struct.new(:name,:firm_id,:id)
  
end
class Firm < Struct.new(:name,:subdomain,:id)
  
end