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
	def to_pdf
	  host        = Rails.env.production? ? 'squadlink.com' : 'lvh.me:3000'
	  url         = Rails.application.routes.url_helpers.show_pdf_url(:id => id, :host => host, :subdomain => firm.subdomain)
	  cookie      = { 'our_very_very_long_secret' => firm.users.first.id } # must be admin user
	  res         = Shrimp::Phantom.new(url, {}, cookie).to_pdf("#{Rails.root}/tmp/shrimp/invoice_#{self.id}.pdf")
	  puts(url)
	end
	
end
