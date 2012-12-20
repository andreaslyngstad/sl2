class TimesheetsController < ApplicationController
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
  def timesheet_create
    
  end
  def timesheet_update
    
  end
  def add_log_timesheet
    @dates = (Time.now.beginning_of_week.to_date)..(Time.now.end_of_week.to_date)
    @log = LogWorker.create(params[:log], params[:done], current_user, current_firm)
    respond_to do |format|
      if @log.save
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
  end
  
  def timesheet_month
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    @users = current_firm.users
    @user = current_firm.users.find(params[:user_id])
    @logs_by_date = @user.logs.group("date(log_date)").sum(:hours)
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
end