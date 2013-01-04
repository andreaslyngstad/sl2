class EmployeesController < ApplicationController

  def create
    @employee = Employee.new(params[:employee])
	  @customer = @employee.customer
	  @employee.firm = current_firm
    respond_to do |format|
      if @employee.save
        flash[:notice] = flash_helper("Employee was successfully saved.") 
        format.js
      else
        flash[:notice] = flash_helper("Employee was not saved.")
        format.js
      end
    end
  end

  def update
    @employee = Employee.find(params[:id])
    @customer = @employee.customer
    respond_to do |format|
      if @employee.update_attributes(params[:employee])
        flash[:notice] = flash_helper("Employee was successfully saved.")
        format.js
      else
        flash[:notice] = flash_helper("Employee was not saved.")
        format.js
      end
    end
  end

  def destroy
    @employee = Employee.find(params[:id])
    @employee.destroy
    respond_to do |format|
       flash[:notice] = flash_helper("Employee was deleted.")
      format.js
    end
  end
end
