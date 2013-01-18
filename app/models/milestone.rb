class Milestone < ActiveRecord::Base
  
  attr_accessible :goal,:due,:completed,:project_id,:created_at,:updated_at, :project,:firm
  belongs_to :project
  belongs_to :user
  belongs_to :firm
  validates_presence_of :goal
  scope :overdue, where(["due < ?",  Date.today])
  scope :due_this_week, where(due:  Date.today, :completed => false)
  validate :made_on_current_firm
  def self.milestones_reflections
    arr = reflections.collect{|a, b| b.class_name.downcase if b.macro==:belongs_to}.compact.uniq
    arr.delete("firm")
    arr
  end
  def check_if_current_firm 
    Milestone.milestones_reflections.map do |ass|  
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
  
  def self.user_milestones_two_weeks(firm, user)
    where(:firm_id => firm.id, :project_id => user.projects, :due => Time.current - 1.year..Time.current + 1.week).order("due ASC")
  end
  def self.user_milestones_overdue(firm, user)
    where(:firm_id => firm.id, :project_id => user.projects).where(["due < ?",  Date.today])
  end
  
  def overdue?
    due < Date.today
  end 
end
