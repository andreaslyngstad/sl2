module InvoiceSender
	extend self
	def give_invoice_number(invoice,last_invoice)
		if invoice.number.nil?
	    if last_invoice
	      invoice.number = last_invoice.number + 1
	    else
	      invoice.number = invoice.firm.starting_invoice_number
	    end
  	end
	end
	
	def invoice_to_pdf(invoice_id)
		Invoice.find(invoice_id).to_pdf
	end

	def pdf_finished?(invoice)
		File.exists?("#{Rails.root}/tmp/shrimp/#{invoice.firm.subdomain}_#{invoice.number}.pdf")
	end
	
	def set_email(firm, user)
		if firm.invoice_email
			"#{firm.name} <#{firm.invoice_email}>"
		else
			"#{user.name} <#{user.email}>"
		end
	end

	def delete_old_files
		require 'fileutils'; Dir.glob("#{Rails.root}/tmp/shrimp/*.*").each{|f| File.delete(f) if File.mtime(f) < ( Time.now - (3600*24)) }
	end
end