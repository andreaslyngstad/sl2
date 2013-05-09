class TimesheetsController < ApplicationController
  def timesheet_week    
     @user = current_firm.users.find(params[:user_id])
     find_users(@user)
      variables_bag
  end
  def timesheet_create
    
  end
  def timesheet_update
    
  end
  def add_log_timesheet
    @user = current_firm.users.find(params[:log][:user_id])
    @log = LogWorker.create(params[:log], params[:done], @user, current_firm)
    variables_bag
    
    respond_to do |format|
      if @log.save
        flash[:notice] = flash_helper('Log was successfully created.')
        format.js
      else
        format.js { render "shared/validate_create" }
      end
    end
  end
  
  def timesheet_day
    @user = current_firm.users.find(params[:user_id])
    find_users(@user)
    @logs = @user.logs.where(:log_date => params[:date])
  end
  
  def timesheet_month
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    @user = current_firm.users.find(params[:user_id])
    find_users(@user)
    @logs_by_date = @user.logs.group("date(log_date)").sum(:hours)
  end
  
  def add_hour_to_project
    @dates = (Time.now.beginning_of_week.to_date)..(Time.now.end_of_week.to_date)
    @log = Log.find_by_id(params[:log_id]) || Log.new
    @log.user = User.find(params[:user_id])
    @log.firm = current_firm
    @log.project = Project.find(params[:project_id])
    @log.log_date = params[:date]
    @log.event = "Added on timesheet"
    @log.begin_time = @log.log_date.beginning_of_day
    if params[:val_input].include?(":")
      a = params[:val_input].split(":")
      b = a[0].to_f + a[1].to_f/60
      @log.end_time =  @log.begin_time + (b * 3600)
    else
      @log.end_time =  @log.begin_time + (params[:val_input].to_f * 3600)
    end
    Rails.logger.info(params[:val_input].class)
    
    @log.save!
  end
  
  private 
  
  def find_users(user)
    if user.role != "External user"
     @users = current_firm.users
     else
     @users = []
     end
  end
  def variables_bag
    @dates = (Time.now.beginning_of_week.to_date)..(Time.now.end_of_week.to_date)
     range = Time.zone.today..Time.zone.today + 7.days
     @log_project = @user.logs.where(:log_date => @dates).group("project_id").sum(:hours)
     @log_week = @user.logs.where(:log_date => @dates).group("date(log_date)").sum(:hours)
     @log_week_project = @user.logs.where(:log_date => @dates).group("project_id").group("date(log_date)").sum(:hours)
     @log_week_no_project = @user.logs.where(:log_date => @dates, :project_id => nil).group("date(log_date)").sum(:hours)
     @projects = @user.projects
     @log_total = @user.logs.where(:log_date => range).sum(:hours) 
  end
end