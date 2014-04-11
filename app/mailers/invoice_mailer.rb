class InvoiceMailer < ActionMailer::Base
 default from: "no_reply@squadlink.com"
	def invoice(invoice)
		@invoice = invoice
		@firm = invoice.firm
		file = @firm.subdomain + '_' + invoice.number.to_s + '.pdf'
		attachments[file] = File.read("#{Rails.root}/tmp/shrimp/" + file)
		mail 	to: invoice.mail_to ? invoice.mail_to : invoice.customer.email, 
					reply_to: InvoiceSender.set_email(@firm, @firm.users.where(role: "Admin").first),
					subject: invoice.mail_subject ? invoice.mail_subject : @firm.invoice_email_subject
	end

	def reminder(invoice)
		@firm = invoice.firm
		mail 	to: invoice.customer.email, 
					reply_to: "#{@firm.name} <#{@firm.invoice_email}>",
					subject: "Reminder"
	end
end
