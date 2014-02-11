require "validator"
class Log < ActiveRecord::Base
  include ActiveModel::Validations
  validates_with Validator
  validates_with MadeWithInLimit, on: :create
  
  belongs_to :customer
  belongs_to :user
  belongs_to :firm, :counter_cache => true
  belongs_to :project
  belongs_to :todo
  belongs_to :employee
  belongs_to :invoice
  before_save :set_hours 
  validate :log_made_on_project
  validate :end_time_before_begin_time
  validates_presence_of :log_date 
  
  
  def log_made_on_project
    errors.add(:project_id, "cannot be empty for this log") if
    user.can_validate? && project == nil
  end

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