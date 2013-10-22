class InvoicesController < ApplicationController
  respond_to :html, :js, :json
  def index
    @invoices = current_firm.invoices.order_by_invoice_number
    @invoice = Invoice.new
  end

  def show  
    @klass = current_firm.invoices.find(params[:id])
    authorize! :read, @klass
    respond_with(@klass)
  end

  def edit
    @invoice = current_firm.invoices.find(params[:id])
    authorize! :read, @invoice
    respond_with(@invoice)
  end

  def create
    @invoice = current_firm.invoices.new(permitted_params.invoice)
    respond_to do |format|
      if @invoice.save
        flash[:notice] = flash_helper("Invoice is added.")
        format.js 
        else
          flash[:notice] = flash_helper("Wrong.")
        format.js { render "shared/validate_create" }
      end
     end
  end
  
  def update
    @invoice = current_firm.invoices.find(params[:id])
    if @invoice.update_attributes(permitted_params.invoice)
      flash[:notice] = flash_helper('Invoice was successfully updated.')
      respond_to do |format|
        format.js
      end
    else
      respond_to do |format|
        format.js
      end
    end
  end

  # def destroy
  #   @invoice = Invoice.find(params[:id])
  #   @invoice.destroy   
  #   respond_to do |format|
  #     flash[:notice] = flash_helper('Invoice was successfully deleted.')
  #     format.js
  #   end
  # end
end
