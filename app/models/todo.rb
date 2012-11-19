class Todo < ActiveRecord::Base
  belongs_to :customer
  belongs_to :project
  belongs_to :user
  belongs_to :firm
  has_many :logs
 
  validates_presence_of :name
  
   def self.not_complete
    where(:completed => false)
  end
  scope :overdue_and_to_day, not_complete.where(["due <= ?",  Date.today])
  scope :due_to_day, where(due:  Date.today, :completed => false)
  
  def due_to_day
    Time.now.strftime("%Y%j") == due.strftime("%Y%j") && completed == false
  end
  
  def overdue
    Time.now.in_time_zone.strftime("%Y%j") > due.strftime("%Y%j") && completed == false
  end
end
