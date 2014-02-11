class InvoiceLine < ActiveRecord::Base
	belongs_to :invoice
	validates_presence_of :description
end
