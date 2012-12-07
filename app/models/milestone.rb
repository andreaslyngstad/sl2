class Milestone < ActiveRecord::Base
  attr_accessible :goal,:due,:firm_id,:completed,:project_id,:created_at,:updated_at, :project,:firm
  belongs_to :project
  belongs_to :user
  belongs_to :firm
  validates_presence_of :goal
  scope :overdue, where(["due < ?",  Date.today])
  scope :due_this_week, where(due:  Date.today, :completed => false)
  
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
