class LogsController < ApplicationController

  # GET /logs
  # GET /logs.xml
  def index
    @all_projects = current_user.projects.where(["active = ?", true])
    @customers = current_firm.customers
    
    @logs = current_firm.logs.where(:log_date => Date.today).order("updated_at DESC").includes(:project, :todo, :user, :customer, :employee )
    if !current_user.logs.blank?
    @log = current_user.logs.where("end_time IS ?",nil).last
    if @log.nil?
       @log_new = Log.new
    end
 	else
 	 @log_new = Log.new
 	end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @logs }
      format.js
    end
  end

  
  def create
    
    @log = Log.new(params[:log])
    @log.tracking = false
    @all_projects =  current_user.projects.where(["active = ?", true])
    @customers = current_firm.customers
    
    @log.firm = current_firm
 	 @model = "log"
      @model_instanse = @log
    if params[:done]
      if !@log.todo.nil?
         @log.todo.completed = true
         @log.todo.save
      end
    end
    
    respond_to do |format|
      if @log.save
        flash[:notice] = flash_helper('Log was successfully created.')
        format.xml  { render :xml => @log, :status => :created, :location => @log }
        format.js
      else
       format.js { render "shared/validate_create" }
      end
    end
  end

  # PUT /logs/1
  # PUT /logs/1.xml
  def update
  	 	@log = Log.find(params[:id])
      @all_projects = current_user.projects.where(["active = ?", true]).includes(:customer, {:todos => [:logs]})
      @customers = current_firm.customers
      @projects = current_firm.projects.where(["active = ?", true])
     
      @model = "log"
      @model_instanse = @log
     # regular update 
    if !@log.todo.nil?
      if params[:done] == "1" 
      	
         @log.todo.completed = true
         @log.todo.save!
       
      elsif params[:done].nil?
      	
         @log.todo.completed = false
         @log.todo.save!
      
    end
    end
    
    respond_to do |format|
      if @log.update_attributes!(params[:log])
        flash[:notice] = flash_helper("Log was successfully saved.")
        format.js
      else
        format.js { render "shared/validate_update" }
        
      end
    end
  end

  # DELETE /logs/1
  # DELETE /logs/1.xml
  def destroy
    @log = Log.find(params[:id])
    @log.destroy
    
    respond_to do |format|
      flash[:notice] = flash_helper('Log was deleted.')
      format.html { redirect_to logs_path }
      format.xml  { head :ok }
      format.js
    end
  end
  def start_tracking
  	 # Start tracing
  	@all_projects =  current_user.projects.where(["active = ?", true])
    @customers = current_firm.customers
    
   	@log = Log.new(params[:log])
   	@log.user = current_user
    @log.firm = current_firm
    @log.tracking = true
    @log.begin_time = Time.now
    @log.log_date = Date.today
      if params[:done]
	      if !@log.todo.nil?
	         @log.todo.completed = true
	         @log.todo.save
	      end
      end
       respond_to do |format|
      if @log.save
        flash[:notice] = flash_helper('Log was successfully created.')
        format.js
      else
       format.js { render "shared/validate_create" }
      end
    end
    
  end
  def stop_tracking
		 # End tracking
	  @all_projects =  current_user.projects.where(["active = ?", true])
    @customers = current_firm.customers
    @log_new = Log.new
  	@log = Log.find(params[:id])
    @log.end_time = Time.now
    
	    if !@log.todo.nil?
	      if params[:done] == "1" 
         @log.todo.completed = true
         @log.todo.save!
      		elsif params[:done].nil?
         @log.todo.completed = false
         @log.todo.save!
    		end
	    end    
	    respond_to do |format|
      if @log.update_attributes!(params[:log])
        flash[:notice] = flash_helper("Log was successfully saved.")
        format.js
      else
        format.js { render "shared/validate_update" }
        
      end
    end
    end
    
   def project_todos
    check_log_status(params[:log_id]) 
    if params[:project_id] != "0"
    @project = Project.find(params[:project_id])
    @todos = @project.todos.where(["completed = ?", false])
    else
    @todos = "Select a project"
    end
  end
  
  def customer_employees
    if params[:log_id] != "0"
    @log = Log.find(params[:log_id])
    end
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
  def todo_select_tracking
    check_log_status(params[:log_id])
    if params[:todo_id] != "0"
      @todo = Todo.find(params[:todo_id])
      if !@log.nil?
        @log.todo = @todo
          if !@todo.customer.nil?
            @log.customer = @todo.customer
          else
            @log.customer = nil
            @log.employee = nil
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
  
    if params[:log_id] != "0"
      @log = Log.find(params[:log_id])
     
      if params[:customer_id] != "0"
        @customer = Customer.find(params[:customer_id])
        @employees = @customer.employees 
          # if @log.try(:customer) != @customer
            # @log.empolyee = nil
          # end
        @log.customer = @customer
        @log.employee = nil 
        @log.save
        flash[:notice] = flash_helper("Log was saved on #{@customer.name}.")
      else
        
        @log.employee = nil
        @log.customer = nil
        @log.save  
        flash[:notice] = flash_helper("Log was saved with no customer.") 
      end
    else
      
     if params[:customer_id] != "0"
        @customer = Customer.find(params[:customer_id])
        @employees = @customer.employees 
    end
    end
  end
  def employee_select_tracking
    if params[:log_id] != "0"
    @log = Log.find(params[:log_id])
    end
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
	def get_logs_todo
	  @todo = Todo.find(params[:todo_id])
	  @logs = @todo.logs
	  @all_projects = current_user.projects.where(["active = ?", true])
	  @customers = current_firm.customers
	end
end
