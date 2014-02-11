class InvoicesController < ApplicationController
  respond_to :html, :js, :json, :pdf
  layout :resolve_layout
  def index
    @invoices = current_firm.invoices.includes(:customer).order_by_number
    @invoice = Invoice.new
    @logs = current_firm.logs.includes(:customer, {:customer => :employee}, :project, {:project =>:todo}, :user)
  end
  def new
    @invoice = current_firm.invoices.new
    if params[:url] == "index" or params[:url] == "new"
      @logs = []
    else
      @instance = eval(params[:url]).find(params[:id])
      klass = params[:url].downcase 
      @logs = @instance.logs.where("end_time IS NOT NULL").order("log_date DESC").includes(:customer, {:customer => :employee}, :project, {:project =>:todo}, :user)
      @invoice.send(klass+'=', @instance)
    end
  end

  def show  
    @klass = current_firm.invoices.find(params[:id])
    authorize! :read, @klass
    respond_with(@klass)
  end 

  def show_pdf
    @klass = current_firm.invoices.find(params[:id])
    authorize! :read, @klass
    @logs = @klass.logs.order(:log_date).includes(:user, :project, :todo, :customer, :employee)
    respond_with(@klass)
  end

  def edit
    @invoice = current_firm.invoices.find(params[:id])
    @logs = @invoice.logs.includes(:customer, :project, {:project => :firm}, :user, :firm, :employee, :todo)
    authorize! :read, @invoice
    respond_with(@invoice)
  end


  def create
    @klass = current_firm.invoices.new(permitted_params.invoice)
    @klass.set_status_and_currency(current_firm)
    @logs = params[:logs_attributes]

    if @logs
      @logs.each do |k,v|
        log = current_firm.logs.find(k.to_i)
        log.update_attributes(v)
        @klass.logs << log
        log.save
      end
    end

    respond_to do |format|
      if @klass.save
        flash[:notice] = flash_helper((t'activerecord.models.invoice.one') + ' ' + (t'activerecord.flash.saved'))
        format.js 
        else
          flash[:notice] = flash_helper((t'activerecord.models.invoice.one') + ' ' + (t'activerecord.flash.could_not_save'))
        format.js { render "shared/validate_create" }
      end
     end

  end
  
  def update
    @klass = current_firm.invoices.find(params[:id])
    logs = params[:logs_attributes]
    Log.update(logs.keys, logs.values) if logs
    if @klass.update_attributes(permitted_params.invoice)
      flash[:notice] = flash_helper((t'activerecord.models.invoice.one') + ' ' + (t'activerecord.flash.saved'))
      respond_to do |format|
        format.js
      end
    else
      flash[:notice] = flash_helper((t'activerecord.models.invoice.one') + ' ' + (t'activerecord.flash.could_not_save'))
      respond_to do |format|
        format.js { render "shared/validate_update" }
      end
    end
  end
  def sending_invoice
    @invoice = current_firm.invoices.find(params[:id])
    @invoice.number = current_firm.invoices.where('number IS NOT NULL').order("number ASC").last.number + 1
    if @invoice.save
      InvoiceMailer.send_invoice(s).deliver
    else
    end
  end
  def destroy
    @invoice = Invoice.find(params[:id])
    @invoice.destroy   
    respond_to do |format|
      flash[:notice] = flash_helper((t'activerecord.models.invoice.one') + ' '  + (t'activerecord.flash.deleted'))
      format.js
    end
  end
  def customer_select
    @customer = current_firm.customers.find(params[:id])
    if !params[:other_object].blank?
      @project = current_firm.projects.find(params[:other_object])
      @logs = @customer.logs.where(invoice_id: nil, project_id: @project.id).includes(:employee, :customer, :firm, :todo, :user, :project)
    else
      @logs = @customer.logs.where(invoice_id: nil).includes(:employee, :customer, :firm, :todo, :user, {:project => :firm})
    end
  end
  def project_select
    @project = current_firm.projects.find(params[:id])
    @customer = @project.customer
    if !params[:other_object].blank? and @customer.nil?
      @selected_customer = current_firm.customers.find(params[:other_object])
      @logs = @project.logs.where(invoice_id: nil, customer_id: @selected_customer.id).includes(:employee, :customer, :firm, :todo, :user, :project)
    else
      @logs = @project.logs.where(invoice_id: nil).includes(:employee, :customer, :firm, :todo, :user, :project)
    end
    if params[:invoice] != "null"
      @invoice = Invoice.find(params[:invoice]) if params[:invoice]
    end
  end
  def customers_create
    @klass = current_firm.customers.new(permitted_params.customer) 
    authorize! :manage, @klass
    respond_to do |format|
      if @klass.save
        flash[:notice] = flash_helper((t'activerecord.models.customer.one') + ' ' + (t'activerecord.flash.saved'))
        format.js 
        else
        format.js { render "shared/validate_create" }
      end
    end 
  end
  def projects_create
    @klass = current_firm.projects.new(permitted_params.project)
    @klass.active = true
    @klass.users << current_user
    authorize! :manage, @klass
    respond_to do |format|
      if @klass.save
        flash[:notice] = flash_helper((t'activerecord.models.project.one') + ' ' + (t'activerecord.flash.saved'))
        format.js
      else
        format.js { render "shared/validate_create" }
      end
    end
  end
  private

  def resolve_layout
    case action_name
    when "show_pdf"
      "pdf"
    else
      "application"
    end
  end

end
