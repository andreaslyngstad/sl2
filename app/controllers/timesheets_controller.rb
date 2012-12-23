class TimesheetsController < ApplicationController
  def timesheets 
     @user = current_firm.users.find(params[:user_id])
     @users = current_firm.users
     @dates = (Time.now.beginning_of_week.to_date)..(Time.now.end_of_week.to_date)
     range = Time.zone.today..Time.zone.today + 7.days
     @log_project = @user.logs.where(:log_date => @dates).group("project_id").sum(:hours)
     @log_week = @user.logs.where(:log_date => @dates).group("date(log_date)").sum(:hours)
     @log_week_project = @user.logs.where(:log_date => @dates).group("project_id").group("date(log_date)").sum(:hours)
     @log_week_no_project = @user.logs.where(:log_date => @dates, :project_id => nil).group("date(log_date)").sum(:hours)
     @projects = @user.projects
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
  
  def add_hour_to_project
    @log = Log.new
    @log.user = User.find(params[:user_id])
    @log.firm = current_firm
    @log.project = Project.find(params[:project_id])
    @log.log_date = params[:date]
    @log.event = "Added on timesheet"
    @log.begin_time = @log.log_date.beginning_of_day
    @log.end_time =  @log.begin_time + (params[:val_input].to_f * 3600)
    Rails.logger.info("Log #{@log.event}") 
    @log.save!
  end
end