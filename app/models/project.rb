class Project < ActiveRecord::Base
  attr_accessible :name,:description,:due,:active,:budget,:hour_price,:customer_id,:created_at,:updated_at,:customer
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
  validate :made_on_current_firm

  def made_on_current_firm
    errors.add(:firm_id, "is secure!") if
    if customer 
       firm != customer.firm 
    end 
  end
end 