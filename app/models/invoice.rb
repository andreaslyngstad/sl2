require "validator"
class Invoice < ActiveRecord::Base
	include ActiveModel::Validations
  validates_with Validator
	belongs_to :project, :counter_cache => true
	belongs_to :customer, :counter_cache => true
	belongs_to :firm, :counter_cache => true
	
	has_many 	 :logs
	has_many	 :invoice_lines
	
	
	validates_presence_of :customer_id
	
	accepts_nested_attributes_for :invoice_lines, allow_destroy: true
	
	scope :order_by_number, -> {order("number DESC")}

	
	def set_status_and_currency(current_firm)
		self.status = 1
		self.currency = current_firm.currency
	end

	def customer_all
		Customer.unscoped.where(id: customer_id).first
	end

	def status_string
		case status
			when 1 then I18n.translate('economic.invoice_draft')	
	  	when 2 then	I18n.translate('economic.invoice_sent')
	  	when 3 then I18n.translate('economic.invoice_due')
	  	when 4 then I18n.translate('economic.invoice_overdue')
	  	when 5 then I18n.translate('economic.invoice_reminded')
		end
	end
	
	def number_string
		if number.nil?
			I18n.translate('economic.invoice_no_number')	
		else
			number
		end
	end

end
