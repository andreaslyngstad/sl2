class JobsController < ApplicationController
  respond_to :html, :js, :json
  layout :resolve_layout
  include InvoiceSender
	def show_pdf 
    @klass = current_firm.invoices.find(params[:id])
    authorize! :read, @klass
    @logs = @klass.logs.order(:log_date).includes(:user, :project, :todo, :customer, :employee)
  end

 
  def create_slow_sending
    @invoice = current_firm.invoices.find(params[:id])
     if @invoice.update_attributes(permitted_params.invoice_send)
      InvoiceSender.give_invoice_number(@invoice,Invoice.last_with_number(current_firm)) 
      QC.enqueue "InvoiceSender.invoice_to_pdf", @invoice.id
    else
     
    end
  end
  def handeling_invoice
    @invoice = current_firm.invoices.find(params[:id])
    sending_tasks(@invoice)
  end

  def fetch_job
    invoice = current_firm.invoices.find(params[:id])
    if InvoiceSender.pdf_finished?(invoice)
       render :status => 200, :json => {file: "#{current_firm.subdomain}_#{invoice.number}.pdf", id: params[:id] }
    else
      render :status => 202, :text => ''
    end
  end

  def ajax_download
    send_file("#{Rails.root}/tmp/shrimp/" + params[:file], :filename => params[:file],  :type=>"application/pdf" )
  end

  def ajax_sending
    @klass = current_firm.invoices.find(params[:id])
    @klass.status = 2
    @klass.save 
    InvoiceMailer.invoice(@klass).deliver
    flash[:notice] = flash_helper((t'activerecord.models.invoice.one').capitalize + ' ' + @klass.number.to_s + ' ' + (t'general.was_sent'))
    # send_file("#{Rails.root}/tmp/shrimp/test.txt", :filename => "test.txt",  :type=>"application/pdf" )
  end

  def time_out
    @klass = current_firm.invoices.find(params[:id])
    flash[:notice] = flash_helper((t'general.generation_of') + ' ' + (t'activerecord.models.invoice.one').capitalize + ' ' + @klass.number.to_s + ' ' + (t'general.timed_out'))

  end
  
  def invoice_paid
    @klass = current_firm.invoices.find(params[:id])
    @klass.paid!
  end
  
  private
  
  def sending_tasks(invoice)
    InvoiceSender.give_invoice_number(invoice,Invoice.last_with_number(current_firm)) 
    if invoice.save
      QC.enqueue "InvoiceSender.invoice_to_pdf", invoice.id
      render :status => 200, :json => { id: invoice.id }
    else
      render :status => 202, :json => {flash: invoice.errors.first}
    end   
  end

  def resolve_layout
    case action_name
    when "show_pdf"
      "pdf"
    else
      "application"
    end
  end

end
