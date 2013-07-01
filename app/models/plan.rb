class Plan < ActiveRecord::Base
  attr_accessible :name, :price,:customers, :logs, :projects, :users,:paymill_id
  has_many :subscriptions
  has_many :firms, :through => :subscriptions
  validates_presence_of :paymill_id
end