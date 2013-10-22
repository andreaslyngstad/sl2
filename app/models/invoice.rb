class Invoice < ActiveRecord::Base
	belongs_to :project
	belongs_to :customer
	belongs_to :firm
	has_many 	 :logs
	validates_presence_of :invoice_number
	validates_presence_of :customer_id
	scope :order_by_invoice_number, -> {order("invoice_number DESC")}
end
