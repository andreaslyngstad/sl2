class Log < ActiveRecord::Base
	
  validate :end_time_before_begin_time
  belongs_to :customer
  belongs_to :user
  belongs_to :firm
  belongs_to :project
  belongs_to :recent_project, :class_name => "Project", :conditions => ['logs.log_date > ?', Time.now.beginning_of_week]
  belongs_to :todo
  belongs_to :employee
  
  before_save :set_hours

  
  def time_diff(time)
  	seconds    	=  (time % 60).to_i
    time 		= (time - seconds) / 60
    minutes    	=  (time % 60).to_i
    time 		= (time - minutes) / 60
    hours      	=  (time).to_i
    if minutes == 0 
    	return hours.to_s + ":00"
    elsif minutes < 10
    	return hours.to_s + ":0" + minutes.to_s
	else
  		return hours.to_s + ":" + minutes.to_s
  	end
  end
 
  def total_time
  	time_diff(hours)
  end
  def set_hours
  	if end_time?
  	self.hours = end_time - begin_time
  	end
  end

  def time
  	end_time - begin_time
  end
  
  def end_string
    end_time.to_s(:db)
  end
  
  def end_string=(end_str)
    self.end_time = Time.parse(end_str)
  end
  
  def begin_string
    begin_time.to_s(:db)
  end
    
  def begin_string=(begin_str)
    self.begin_time = Time.parse(begin_str)
  end
  def date
  self.log_date.strftime('%d.%m.%y')
	end
  
  def end_time_before_begin_time
    errors.add(:end_time, "You end before you begin.") if
    if tracking != true
    (end_string=(end_time) < begin_string=(begin_time))
    end
  end
  def presence_of_event
  	if tracking != true
  	validates_presence_of :event
  	end
  end
  def log_date_format
    log_date.strftime("%Y%m%d")
  end
  
  def self.chart_data(firm, start = 3.weeks.ago)
    
    logs = Log.logs_by_day(start, firm)
    # a = []
    # users = firm.users.all   
    (start.to_date..Date.today).map do |date|
      
      end
  end
  def self.hours_by_day_and_user(firm, range)
    logs = firm.logs.where(log_date: range).includes(:user).group([:log_date, :user_id]).select("sum(hours) as total_hours, log_date, user_id")     
  end
  def self.hours_by_day_and_project(firm, range)
    logs = firm.logs.where(log_date: range).includes(:project).group([:log_date, :project_id]).select("sum(hours) as total_hours, log_date, project_id")     
  end
end
 
