class Log < ActiveRecord::Base
	attr_accessible :event,:customer_id,:user_id,:project_id,:employee_id,:todo_id,:tracking,:begin_time,:end_time,:log_date,
	 :hours,:created_at,:updated_at,:project,:customer,:user,:todo, :firm
  
  belongs_to :customer
  belongs_to :user
  belongs_to :firm, :counter_cache => true
  belongs_to :project
  belongs_to :recent_project, :class_name => "Project", :conditions => ['logs.log_date > ?', Time.now.beginning_of_week]
  belongs_to :todo
  belongs_to :employee
  before_save :set_hours 
  validate :log_made_on_current_firm
  validate :log_made_on_project
  validate :end_time_before_begin_time
  validate :made_with_in_limit, :on => :create
   
  
  def made_with_in_limit
    errors.add(:customer_id, "You have reached your plans limit of #{firm.plan.logs} logs. Please upgrade.") if
    PlanLimit.new.over_limit?(firm.logs_count, firm.plan.logs)
  end 

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
  
  
  def log_made_on_project
    errors.add(:project_id, "cannot be empty for this log") if
    user.can_validate && project == nil
  end
  
 #  def time_diff(time)
 #  	seconds    	=  (time % 60).to_i
 #    time 		= (time - seconds) / 60
 #    minutes    	=  (time % 60).to_i
 #    time 		= (time - minutes) / 60
 #    hours      	=  (time).to_i
 #    if minutes == 0 
 #    	return hours.to_s + ":00"
 #    elsif minutes < 10
 #    	return hours.to_s + ":0" + minutes.to_s
	# else
 #  		return hours.to_s + ":" + minutes.to_s
 #  	end
 #  end
 
  # def total_time
  # 	time_diff(hours)
  # end
  def set_hours
  	if end_time?
  	self.hours = end_time - begin_time
  	end
  end

  def time
    if end_time
  	 end_time - begin_time 
    end
  end
  
  
  def end_time_before_begin_time
    errors.add(:end_time, "You end before you begin.") if
    if tracking != true
      end_time < begin_time
    end
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
  # comment 06.06.13
  # def self.project_try(project)
  #   if project
  #     where(project_id: project)
  #   else
  #     where("end_time IS NOT NULL")
  #   end
  # end
  # def self.user_try(user)
  #   if user
  #     where(user_id: user)
  #   else
  #     where("end_time IS NOT NULL")
  #   end
  # end
  # comment end
  def self.try_find_logs(options)
     options.map do |k,v|
       unless v.blank?
         where(k => v)
       end
     end.compact.inject(:&)
  end
  
  
end