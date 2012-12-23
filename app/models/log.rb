class Log < ActiveRecord::Base
	attr_accessible :event,:customer_id,:user_id,:project_id,:employee_id,:todo_id,:tracking,:begin_time,:end_time,:log_date,
	 :hours,:created_at,:updated_at,:project,:customer,:user,:todo
  validate :end_time_before_begin_time
  belongs_to :customer
  belongs_to :user
  belongs_to :firm
  belongs_to :project
  belongs_to :recent_project, :class_name => "Project", :conditions => ['logs.log_date > ?', Time.now.beginning_of_week]
  belongs_to :todo
  belongs_to :employee
  
  before_save :set_hours
  validate :log_made_on_current_firm
  
  def self.log_reflections
    arr = reflections.collect{|a, b| b.class_name.downcase if b.macro==:belongs_to}.compact.uniq
    arr.delete("firm")
    arr
  end
  def check_if_current_firm 
    Log.log_reflections.map do |ass|  
      parent = eval(ass)
      if parent && parent.firm != nil 
         firm != parent.firm 
      end
    end 
  end
  def log_made_on_current_firm
    errors.add(:firm_id, "is secure!") if
    check_if_current_firm.include?(true) 
  end
  
  
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
  	self.hours = end_time  - begin_time
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
  def self.logs_for_timesheet(user)
    user.logs.where(:log_date => (Date.today.beginning_of_week..Date.today.end_of_week)).group("project_id").group("date(log_date)").sum(:hours)
  end
  
  def self.hours_by_day_and_model(firm, range, model)
    model_id = model.to_s + "_id"
    logs = firm.logs
    .where(:log_date => range)
    .where(Log.arel_table[:end_time].not_eq(nil))
    .includes(model)
    .group([:log_date, model_id.intern])
    .select("sum(hours) as total_hours, log_date, #{model_id}")     
  end
  def self.hours_by_model(firm, range, model)
      model_id = model.to_s + "_id"
     logs = firm.logs
     .where(log_date: range).includes(model)
     .group([model_id.intern])
     .select("sum(hours) as total_hours, #{model_id}")    
  end
  def placed_between?(date_range)
    date_range.include?(log_date)
  end
end