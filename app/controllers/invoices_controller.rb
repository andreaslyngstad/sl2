class InvoicesController < ApplicationController
  respond_to :html, :js, :json
  def index
    @invoices = current_firm.invoices 
  end

  def show  
    @klass = current_firm.invoices.find(params[:id])
    authorize! :read, @klass
    respond_with(@klass)
  end

  def edit
  end

    def create
    @invoice = current_firm.invoices.new(permitted_params.invoice)
    respond_to do |format|
      if @invoice.save
        flash[:notice] = flash_helper('Invoice was successfully created.')
        format.js { render :action => "create_success"}
        else
        format.js { render :action => "failure"}
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
