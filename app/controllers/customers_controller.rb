class CustomersController < ApplicationController
 
  def index
    @customers = current_firm.customers.order_by_name
    @customer = Customer.new  
  end
  def show
    @klass = current_firm.customers.find(params[:id])
    @hours = @klass.logs.sum(:hours)
    @employees = @klass.employees
    @projects = @klass.projects.where(["active = ?", true]).includes(:firm)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @klass }
      format.js
    end
  end
   
  def edit
    @customer = Customer.find(params[:id])
    respond_to do |format|
        format.js 
    end 
  end

  def create
    @customer = Customer.new(params[:customer]) 
    @customer.firm = current_firm
    respond_to do |format|
      if @customer.save
      	flash[:notice] = flash_helper("#{@customer.name}" + " is added.")
      	format.js  
      end
    end 
  end

  def update
    @customer = Customer.find(params[:id])
    respond_to do |format|
      if @customer.update_attributes(params[:customer])
        flash[:notice] = flash_helper("#{@customer.name}" + " was successfully updated.")
        format.js
      else
        format.js
      end
    end
  end

  def destroy
    @customer = Customer.find(params[:id])
    @customer.destroy
      respond_to do |format|
      flash[:notice] = flash_helper('Customer was successfully deleted.')
      format.js
    end  
  end
  # comment 06.06.13
  # def create_project  
  #   @project = Project.new(params[:project])
  #   @project.firm = @firm
  #     respond_to do |format|
  #     if @project.save
  #     flash[:notice] = flash_helper("Project is added.")
  #     format.js
  #     end
  #   end
  # end
  
  # def update_project
    
  # end
  
end