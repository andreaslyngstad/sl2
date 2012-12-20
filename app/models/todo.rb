class Todo < ActiveRecord::Base
  attr_accessible :name,:user_id,:project_id,:customer_id,
  :due,:completed,:created_at,:updated_at,:project,:customer,:user,:done_by_user,:done_by_user_id, :prior
  
  belongs_to :customer
  belongs_to :project
  belongs_to :user
  belongs_to :firm
  belongs_to :done_by_user, :class_name => "User", :foreign_key => "done_by_user"
  has_many :logs
 
  validates_presence_of :name
  validate :made_on_current_firm
  def self.todo_reflections
    arr = reflections.collect{|a, b| b.class_name.downcase if b.macro==:belongs_to}.compact.uniq
    arr.delete("firm")
    arr
  end
  def check_if_current_firm 
    Todo.todo_reflections.map do |ass|  
      parent = eval(ass)
      if parent && parent.firm != nil 
         firm != parent.firm 
      end
    end 
  end
  def made_on_current_firm
    errors.add(:firm_id, "is secure!") if
    check_if_current_firm.include?(true) 
  end
  
  def self.not_complete
    where(:completed => false)
  end
  scope :overdue_and_to_day, not_complete.where(["due <= ?",  Date.today]).order("due")
  scope :due_to_day, where(due:  Date.today, :completed => false)
  
  def due_to_day
    Time.now.strftime("%Y%j") == due.strftime("%Y%j") && completed == false
  end
  
  def overdue
    Time.now.in_time_zone.strftime("%Y%j") > due.strftime("%Y%j") && completed == false
  end
end
