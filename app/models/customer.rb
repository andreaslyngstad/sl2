class Customer < ActiveRecord::Base
  include ActionView::Helpers::UrlHelper
  # attr_accessible :name,:phone,:email,:address,:created_at,:updated_at, :firm
  belongs_to :firm, :counter_cache => true
  has_many :logs
  has_many :todos
  has_many :recent_logs, -> {  where('log_date > ?', Time.now.beginning_of_week).order("log_date DESC") }, :class_name => "Log"
  has_many :projects
  has_many :employees, :dependent => :destroy
  validates_presence_of :name 
  validate :made_with_in_limit, :on => :create
  scope :order_by_name, -> {order("name ASC")}
  
  def made_with_in_limit
    errors.add(:customer_id, "You have reached your plans limit of #{firm.plan.customers} customers. #{link_to "Please upgrade.", Rails.application.routes.url_helpers.plans_path}") if
    PlanLimit.new.over_limit?(firm.customers_count, firm.plan.customers)
  end 
end
