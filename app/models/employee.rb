class Employee < ActiveRecord::Base
  attr_accessible :name,:phone,:email,:customer_id,:created_at,:updated_at,:customer,:firm
  belongs_to :customer
  belongs_to :firm
  has_many :logs
  validates_presence_of :name
  validate :made_on_current_firm

  def made_on_current_firm
    errors.add(:firm_id, "is secure!") if
    if customer 
       firm != customer.firm 
    end 
  end
end
