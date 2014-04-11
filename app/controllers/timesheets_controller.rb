class TimesheetsController < ApplicationController
  include TabsHelper 
  include FormatHelper
  def timesheet_day
    @user = current_firm.users.find(params[:user_id])
    find_users(@user)
    @date = params[:date]
    @logs = @user.logs.where(:log_date => params[:date])
  end

  def timesheet_week  
    get_instance_if_not_index(params) 
    if !params[:user_id].blank?
      @user = current_firm.users.find(params[:user_id])
    end
    date = params[:date] ? Date.parse(params[:date]) : Date.today
    @dates = (date.beginning_of_week.to_date)..(date.end_of_week.to_date)
    find_users(current_user)
    variables_bag(@klass, @user)
  end

  def timesheet_month
    get_instance_if_not_index(params)
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    if !params[:user_id].blank?
      @user = current_firm.users.find(params[:user_id])
      if @klass
        @logs_by_date = @klass.logs.where(user_id: @user.id).group("date(log_date)").sum(:hours)
      else
        @logs_by_date = @user.logs.group("date(log_date)").sum(:hours)
      end
    else
      if @klass
        @logs_by_date = @klass.logs.group("date(log_date)").sum(:hours)
      else
        @logs_by_date = current_firm.logs.group("date(log_date)").sum(:hours)
      end
      
    end
    find_users(current_user)
    
  end
 
  def add_log_timesheet
    date = params[:log][:log_date] ? Date.parse(params[:log][:log_date]) : Date.today
    @dates = (date.beginning_of_week.to_date)..(date.end_of_week.to_date)
    @user = current_firm.users.find(params[:log][:user_id])
    @log = LogWorker.create(current_firm.logs.new(permitted_params.log), params[:done], @user, current_firm)
    variables_bag(@user)
    
    respond_to do |format|
      if @log.save
        format.js
      else
        format.js { render "shared/validate_create" }
      end
    end
  end
  
  def add_hour_to_project
    @log = Log.find_by_id(params[:log_id]) || current_firm.logs.new
    select_klass = params[:select_klass]
    klass        = params[:klass]
    
    @log.send(select_klass + '=', current_firm.send(params[:select_klass].pluralize).find(params[:select_id]))
    @log.send(klass + '=', current_firm.send(params[:klass].pluralize).find(params[:id]))
    @dates = (Time.now.beginning_of_week.to_date)..(Time.now.end_of_week.to_date)
    @log.log_date = params[:date]
    @log.event = date_format(Date.today)
    @log.begin_time = @log.log_date.beginning_of_day
    @log.firm = current_firm
    if params[:val_input].include?(":")
      a = params[:val_input].split(":")
      b = a[0].to_f + a[1].to_f/60
      @log.end_time =  @log.begin_time + (b * 3600)
    else
      @log.end_time =  @log.begin_time + (params[:val_input].to_f * 3600)
    end
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
  def variables_bag(klass, user)
    if klass.class == Project
      @projects = current_user.firm.users
      @log_project = klass.logs.where(:log_date => @dates).group("user_id").sum(:hours)
      @log_week = klass.logs.where(:log_date => @dates).group("date(log_date)").sum(:hours)
      @log_week_project = klass.logs.where(:log_date => @dates).group("user_id").group("date(log_date)").sum(:hours)
      # @log_week_no_project = klass.logs.where(:log_date => @dates, :project_id => nil).group("date(log_date)").sum(:hours)
      @log_total = klass.logs.where(:log_date => @dates).sum(:hours) 
    
    elsif klass.class == Customer or klass.class == User
      @projects = current_user.projects
      if user
      @log_project = klass.logs.where(user_id: user.id).where(:log_date => @dates).group("project_id").sum(:hours)
      @log_week = klass.logs.where(user_id: user.id).where(:log_date => @dates).group("date(log_date)").sum(:hours)
      @log_week_project = klass.logs.where(user_id: user.id).where(:log_date => @dates).group("project_id").group("date(log_date)").sum(:hours)
      @log_week_no_project = klass.logs.where(user_id: user.id).where(:log_date => @dates, :project_id => nil).group("date(log_date)").sum(:hours)
      @log_total = klass.logs.where(user_id: user.id).where(:log_date => @dates).sum(:hours)   
      else
      @log_project = klass.logs.where(:log_date => @dates).group("project_id").sum(:hours)
      @log_week = klass.logs.where(:log_date => @dates).group("date(log_date)").sum(:hours)
      @log_week_project = klass.logs.where(:log_date => @dates).group("project_id").group("date(log_date)").sum(:hours)
      @log_week_no_project = klass.logs.where(:log_date => @dates, :project_id => nil).group("date(log_date)").sum(:hours)
      @log_total = klass.logs.where(:log_date => @dates).sum(:hours)     
      end
    else
      if current_user.admin?
        if user
        @projects             = current_firm.projects
        @log_project          = current_firm.logs.where(user_id: user.id).where(:log_date => @dates).group("project_id").sum(:hours)
        @log_week             = current_firm.logs.where(user_id: user.id).where(:log_date => @dates).group("date(log_date)").sum(:hours)
        @log_week_project     = current_firm.logs.where(user_id: user.id).where(:log_date => @dates).group("project_id").group("date(log_date)").sum(:hours)
        @log_week_no_project  = current_firm.logs.where(user_id: user.id).where(:log_date => @dates, :project_id => nil).group("date(log_date)").sum(:hours)
        @log_total            = current_firm.logs.where(user_id: user.id).where(:log_date => @dates).sum(:hours)  
        else
        @projects             = current_firm.projects
        @log_project          = current_firm.logs.where(:log_date => @dates).group("project_id").sum(:hours)
        @log_week             = current_firm.logs.where(:log_date => @dates).group("date(log_date)").sum(:hours)
        @log_week_project     = current_firm.logs.where(:log_date => @dates).group("project_id").group("date(log_date)").sum(:hours)
        @log_week_no_project  = current_firm.logs.where(:log_date => @dates, :project_id => nil).group("date(log_date)").sum(:hours)
        @log_total            = current_firm.logs.where(:log_date => @dates).sum(:hours)  
        end
      else
        @projects             = current_user.projects
        @log_project          = current_firm.logs.where(project_id: projects).where(user_id: user.id).where(:log_date => @dates).group("project_id").sum(:hours)
        @log_week             = current_firm.logs.where(project_id: projects).where(user_id: user.id).where(:log_date => @dates).group("date(log_date)").sum(:hours)
        @log_week_project     = current_firm.logs.where(project_id: projects).where(user_id: user.id).where(:log_date => @dates).group("project_id").group("date(log_date)").sum(:hours)
        @log_week_no_project  = current_firm.logs.where(project_id: projects).where(user_id: user.id).where(:log_date => @dates, :project_id => nil).group("date(log_date)").sum(:hours)
        @log_total            = current_firm.logs.where(project_id: projects).where(user_id: user.id).where(:log_date => @dates).sum(:hours) 
      end
      
  end

    # if klass.class != Project
    #   @projects = klass.projects
    # else
    #   # @projects = current_user.projects.where(id: klass.id )
    # end
  end
  def get_instance_if_not_index(params)
    if params[:id] != "index"
      get_instance(params)
    end
  end
end