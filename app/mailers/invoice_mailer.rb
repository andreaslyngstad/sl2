class InvoiceMailer < ActionMailer::Base
 default from: "no_reply@squadlink.com"
	def invoice(invoice)
					@firm = invoice.firm
		mail 	to: invoice.customer.email, 
					reply_to: "#{@firm.name} <#{@firm.invoice_email}>",
					subject: invoice.firm.invoice_subject
	end

	def reminder(invoice)
		@firm = invoice.firm
		mail 	to: invoice.customer.email, 
					reply_to: "#{@firm.name} <#{@firm.invoice_email}>",
					subject: "Reminder"
	end
end
