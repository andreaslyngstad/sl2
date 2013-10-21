class Project < ActiveRecord::Base
  # attr_accessible :name,:description,:active,:budget,:hour_price,:customer_id,:created_at,:updated_at,:customer
  include ActionView::Helpers::UrlHelper
  belongs_to :firm, :counter_cache => true
  belongs_to :customer
  has_many :todos, :dependent => :destroy
  has_many :logs, :dependent => :destroy
  has_many :recent_logs, -> {  where('log_date > ?', Time.now.beginning_of_week).order("log_date DESC") }, :class_name => "Log"
  has_many :milestones  
  has_many :invoices
  validates_presence_of :name
  has_many :memberships
  has_many :users, :through => :memberships
  scope :is_active, -> {where(["active = ?", true])}
  scope :is_inactive, -> {where(["active = ?", false])}
  scope :order_by_name, -> {order("name ASC")}
  validate :made_on_current_firm
  validate :made_with_in_limit, :on => :create
  
  def made_on_current_firm
    errors.add(:firm_id, "is secure!") if
    if customer 
       firm != customer.firm 
    end  
  end
 
  def made_with_in_limit
    errors.add(:project_id, -> {"You have reached your plans limit of #{firm.plan.projects} projects.  #{link_to "Please upgrade.", Rails.application.routes.url_helpers.plans_path}"}) if
    PlanLimit.new.over_limit?(firm.projects_count, firm.plan.projects)
  end
end 