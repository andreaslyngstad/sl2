require "validator"
class Invoice < ActiveRecord::Base
	include ActiveModel::Validations
	include ActionView::Helpers::TagHelper
  validates_with Validator
	belongs_to :project, :counter_cache => true
	belongs_to :customer, :counter_cache => true
	belongs_to :firm, :counter_cache => true
	
	has_many 	 :logs
	has_many	 :invoice_lines, dependent: :destroy
	
	
	validates_presence_of :customer_id
	
	accepts_nested_attributes_for :invoice_lines, allow_destroy: true
	
	scope :order_by_number, -> {order("number DESC")}
	scope :order_by_date, -> {order('date DESC')}
	scope :with_number, -> (firm) {firm.invoices.where('number IS NOT NULL').order("number ASC")}

	validate :validates_presence_of_legal_attributes

	def self.last_with_number(firm)
		with_number(firm).last
	end
	def validates_presence_of_legal_attributes
    errors.add(:Firm, (I18n.translate"errors.messages.validates_presence_of_legal_attributes")) if
    if !number.blank?
      firm.bank_account.blank? or firm.vat_number.blank?
    end
  end

  def due_today_or_overdue
  	if status == 2
  		if due == Date.today and status != 3
		  	self.status = 3
		  	self.save 
	  	end
	  	if due < Date.today and status != 4
	  		self.status = 4
	  		self.save 
	  	end
  	end
  end

  def paid!
  	if self.paid.nil? 
  		self.paid = Date.today
  		self.status = 6
  	else
	  	self.paid = nil
	  	self.status = 2
  	end
  	save
  end

	def set_status_and_currency(current_firm)
		self.status = 1
		self.currency = current_firm.currency
	end

	def customer_all
		Customer.unscoped.where(id: customer_id).first
	end

	def status_string
		case status
			when 1 then ["black", I18n.translate('economic.invoice_draft')]
	  	when 2 then	["black", I18n.translate('economic.invoice_sent')]
	  	when 3 then ["orange", I18n.translate('economic.invoice_due')]
	  	when 4 then ["red", I18n.translate('economic.invoice_overdue')]
	  	when 5 then ["orange", I18n.translate('economic.invoice_reminded')]
	  	when 6 then ["green", I18n.translate('economic.invoice_paid')]
	  	when 7 then ["grey", I18n.translate('economic.invoice_credit')]
	  	when 8 then ["grey", I18n.translate('economic.credit').capitalize]
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
	  cookie      = { SECRETS_CONFIG[Rails.env][:phantomjs_secret_token] => firm.users.first.id } # must be admin user
	  res         = Shrimp::Phantom.new(url, {}, cookie).to_pdf("#{Rails.root}/tmp/shrimp/#{firm.subdomain}_#{self.number}.pdf")
	  puts(url)
	end
	
end
