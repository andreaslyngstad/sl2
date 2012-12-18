class SelectController < ApplicationController
  def project_select
    check_log_status(params[:log_id]) 
    if params[:project_id] != "0"
    @project = Project.find(params[:project_id])
    @todos = @project.todos.where(["completed = ?", false])
    else
    @todos = "Select a project"
    end
  end
    def project_select_tracking
     check_log_status(params[:log_id])
    if params[:project_id] != "0"
      @project = Project.find(params[:project_id])
      @todos = @project.todos.where(["completed = ?", false])
      if !@log.nil?
        @log.project = @project 
        @log.todo = nil
          if !@project.customer.nil?
            @log.customer = @project.customer
            @log.employee = nil
          else
            @log.customer = nil
            @log.employee = nil
          end    
        @log.save
      end
    else
      @todos = "Select a project"
      if !@log.nil?
      @log.todo = nil
      @log.project = nil
      @log.customer = nil
      @log.employee = nil
      @log.save
      end
    end
  end
  def customer_select
    check_log_status(params[:log_id])
    if params[:customer_id] != "0"
    @customer = Customer.find(params[:customer_id])
    @employees = @customer.employees
    else
    @employees = "Select a customer"
    end
  end
  def todo_select
      check_log_status(params[:log_id])
    if params[:todo_id] != "0"
      @todo = Todo.find(params[:todo_id])    
    end 
  end
  
 
  def todo_select_tracking
    check_log_status(params[:log_id])
    if params[:todo_id] != "0"
      @todo = Todo.find(params[:todo_id])
      if !@log.nil?
        @log.todo = @todo
          if !@todo.customer.nil?
            @log.customer = @todo.customer
          end
        @log.save
      end
    else
      if !@log.nil?
        @log.todo = nil
        @log.customer = nil
        @log.employee = nil
        @log.save
      end
    end
    
  end
  
  def customer_select_tracking
  
    check_log_status(params[:log_id])
      if params[:customer_id] != "0"
        if !@log.nil?
          @customer = Customer.find(params[:customer_id])
          @employees = @customer.employees 
          @log.customer = @customer
          @log.employee = nil 
          @log.save
          flash[:notice] = flash_helper("Log was saved on #{@customer.name}.")
        end
      else
        
        @log.employee = nil
        @log.customer = nil
        @log.save  
        flash[:notice] = flash_helper("Log was saved with no customer.") 
      end
    if @log.nil?
      
     if params[:customer_id] != "0"
        @customer = Customer.find(params[:customer_id])
        @employees = @customer.employees 
    end
    end
  end
  def employee_select_tracking
    check_log_status(params[:log_id])
    if params[:employee_id] != "0"
      @employee = Employee.find(params[:employee_id])
      if !@log.nil?
        @log.employee = @employee 
        @log.save
        flash[:notice] = flash_helper("Log was saved on #{@employee.name} @ #{@employee.customer.name}.")      
      end
    else
      if !@log.nil?
        @log.employee = nil
        @log.save
        @customer = @log.try(:customer)      
        flash[:notice] = flash_helper("Log was saved on #{@customer.name}.")
      end
    end
  end
  
  def check_log_status(params_log_id)
    if params_log_id != "0"
    @log = Log.find(params_log_id)
    end
  end
  
end