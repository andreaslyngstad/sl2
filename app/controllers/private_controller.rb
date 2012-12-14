class PrivateController < ApplicationController


  def account
  end
  
  def statistics
    @log_week = current_firm.logs.where(:log_date => (Time.now.beginning_of_week + 1.second)..(Time.now.end_of_day)).group("date(log_date)").sum(:hours)
 	  @logs_project = current_firm.logs.where(['log_date > ? AND project_id IS NOT ?', Time.now.beginning_of_week, nil]).group("project").sum(:hours)
    
    @logs_customer = current_firm.logs.where(['log_date > ? AND customer_id IS NOT ?', Time.now.beginning_of_week, nil]).group("customer").sum(:hours)
    @logs_user = current_firm.logs.where(['log_date > ?', Time.now.beginning_of_week]).group("user").sum(:hours)
  end


  def reports
  	 @users = current_firm.users
  	 @projects = current_firm.projects
  	 @customers = current_firm.customers
  end
  
  def report_for
  	if !params[:user_id].blank?
  	@user = User.find(params[:user_id])
  	
  	@logs = @user.logs.where(:log_date => (params[:from].to_date + 1.second)..(params[:to].to_date.end_of_day))
  	@projects = @logs.project
  	@logs_hours_by_project = @logs.group("project_id", "date(log_date)")
  	@logs_hours_by_date = @logs.group("date(log_date)").sum(:hours)
  	
  	end
  	if !params[:project_id].blank?
  	@project = Project.find(params[:project_id])
  	end
  	if !params[:customer_id].blank?
  	@customer = Customer.find(params[:customer_id])
  	end
  end
  
  def timesheets 
    @user = current_firm.users.find(params[:user_id])
	  @users = current_firm.users
     @dates = (Time.now.beginning_of_week.to_date)..(Time.now.end_of_week.to_date)
     range = Time.zone.today..Time.zone.today + 7.days
     @log_project = @user.logs.where(:log_date => Time.zone.today..Time.zone.today + 7.days).group("project_id").sum(:hours)
     @log_week = @user.logs.where(:log_date => range).group("date(log_date)").sum(:hours)
     @log_week_project = @user.logs.where(:log_date => range).group("project_id").group("date(log_date)").sum(:hours)
     @log_week_no_project = @user.logs.where(:log_date => range, :project_id => nil).group("date(log_date)").sum(:hours)
     @projects = @user.projects
     @all_projects = @projects
     @customers = current_firm.customers
     @log_total = @user.logs.where(:log_date => range).sum(:hours) 
  end
  
  def add_log_timesheet
    @log = Log.new(params[:log])
    @user = @log.user
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
     timesheet_variables(params)
        flash[:notice] = flash_helper('Log was successfully created.')
        format.html { redirect_to(home_path(@log)) }
        format.xml  { render :xml => @log, :status => :created, :location => @log }
        format.js
      else
       format.js { render "shared/validate_create" }
      end
    end
  end
  
	def timesheet_logs_day
		@users = current_firm.users
		@user = current_firm.users.find(params[:user_id])
		@logs = @user.logs.where(:log_date => params[:date])
		@all_projects = current_user.projects.where(["active = ?", true]).includes(:customer, {:todos => [:logs]})
		@customers = current_firm.customers
	end
	
	def timesheet_month
	  
	  @date = params[:date] ? Date.parse(params[:date]) : Date.today
	  @users = current_firm.users
    @user = current_firm.users.find(params[:user_id])
    @logs_by_date = @user.logs.group("date(log_date)").sum(:hours)
    @all_projects = current_user.projects.where(["active = ?", true]).includes(:customer, {:todos => [:logs]})
    @customers = current_firm.customers
	end
	
 	def add_hours_to_timesheet
 		@project = Project.find(params[:id])	
 		@date = params[:date]
 		@log = Log.new
 		@log.project = @project
 		@log.log_date = @date
 		@log.event = "Added on timesheet"
		@log.begin = @date.beginning_of_day
		@log.end =  @log.begin + params[:hours]	
 	end
 	
  def add_todo_to_logs
    @firm = current_user.firm
    if !params[:todo_id].nil?
      @todo = Todo.find(params[:todo_id]) 
      @log = Log.where("tracking = ?", true).last
      @log.todo = @todo
      @log.project = @todo.project
      if !@todo.project.customer.nil?
        @log.customer = @todo.project.customer
      else
        @log.customer = nil
      end
      @log.save
    else
      @log = Log.where("tracking = ?", true).last
      @log.todo = nil
      @log.project = nil
      @log.customer = nil
      @log.save
    end
  end

  def timesheet_variables(params)
     
  end

  def membership
  	@firm = current_user.firm
  	@project = Project.find(params[:project_id])
  	@user = User.find(params[:id])
  	if @project.users.include?(@user)
  		@project.users.delete(@user)
  		flash[:notice] = flash_helper("#{@user.name} is NOT a member of the #{@project.name} project.")
  	else
  		@project.users << @user
  		flash[:notice] = flash_helper("#{@user.name} is a member of the #{@project.name} project.")
  	end
  	@members = @project.users
  	@not_members = @firm.users - @members	
  end
end

   




