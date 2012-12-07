class Project < ActiveRecord::Base
  attr_accessible :name,:description,:due,:active,:budget,:hour_price,:firm_id,:customer_id,:created_at,:updated_at,:firm,:customer
  belongs_to :firm
  belongs_to :customer
  has_many :todos, :dependent => :destroy
  has_many :logs, :dependent => :destroy
  has_many :recent_logs, :class_name => "Log", :order => "log_date DESC", :conditions => ['log_date > ?', Time.now.beginning_of_week]
  has_many :milestones
  validates_presence_of :name
  has_many :memberships
  has_many :users, :through => :memberships
  scope :is_active, where(["active = ?", true])
  scope :is_inactive, where(["active = ?", false])
  
  
end

 