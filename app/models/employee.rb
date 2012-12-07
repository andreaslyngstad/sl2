class Employee < ActiveRecord::Base
  attr_accessible :name,:phone,:email,:customer_id,:created_at,:updated_at,:customer
  belongs_to :customer
  has_many :logs
end
