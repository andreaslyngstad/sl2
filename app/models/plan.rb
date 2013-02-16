class Plan < ActiveRecord::Base
  attr_accessible :name, :price,:customers, :logs, :projects, :users
  has_many :subscriptions
  has_many :firms, :through => :subscriptions
  validates_presence_of :paymill_id
  def self.free
    where(:price, 0).first
  end
end