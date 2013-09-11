class TimerangeController < ApplicationController
  respond_to :js
  def log_range
    @customers = current_firm.customers.includes(:employees)
    @all_projects = current_user.projects.where(["active = ?", true]).includes(:customer, {:todos => [:logs]})
    if params[:from]
      Rails.logger.info(Date.parse(params[:from]).midnight )
      time_range = ((Date.parse(params[:from]).midnight + 1.day)..(Date.parse(params[:to]).midnight + 1.day ))
    else
      time_range = timerange(params[:time])
    end
    find_logs_on(params[:url], time_range)
    respond_with( @logs)
  end
  
  def todo_range
    @range = "range"
    @klass = eval(params[:url]).find(params[:id])
    if params[:from]
      time_range = ((Date.parse(params[:from]).midnight + 1.day)..Date.parse(params[:to]).midnight + 1.day)
    else
      time_range = timerange(params[:time])
    end
    find_todos_on(params[:url],time_range)
    
    render :template => 'tabs/tabs_todos'
  
  end

  private

  def find_todos_on(url, time_range)
    @done_todos = eval(url).find(params[:id]).todos.where(["completed = ?", true]).where(:due => time_range).order("due ASC").includes(:logs,:project,:user)
    @not_done_todos = eval(url).find(params[:id]).todos.where(["completed = ?", false]).where(:due => time_range).order("due ASC").includes(:logs,:project,:user)
  end

  def find_logs_on(url, time_range)
    if url == "index"
      logs_on = current_firm 
    else
      logs_on = eval(url).find(params[:id])
    end
    @logs = logs_on.logs.where(:log_date => time_range).order("log_date DESC").includes(:project, :todo, :user, :customer, :employee,:firm )
  end

  def timerange(time)
    if time == "to_day"
      time_range = (time_zone_now.midnight)..(time_zone_now.midnight + 1.day)
      elsif time == "this_week"
      time_range = (time_zone_now.beginning_of_week)..(time_zone_now.end_of_week)   
      elsif time == "this_month"
      time_range = (time_zone_now.beginning_of_month)..(time_zone_now.end_of_month)   
      elsif time == "this_year"
      time_range = (time_zone_now.beginning_of_year)..(time_zone_now.end_of_year)   
      elsif time == "yesterday"
      time_range = (time_zone_now.midnight - 1.day)..(time_zone_now.midnight - 1.second)   
      elsif time == "last_week"
      time_range = (time_zone_now.beginning_of_week - 7.day)..(time_zone_now.beginning_of_week - 1.second)   
      elsif time == "last_month"
      time_range = (time_zone_now.beginning_of_month - 1.month)..(time_zone_now.beginning_of_month - 1.second)   
      elsif time == "last_year"
      time_range = (time_zone_now.beginning_of_year - 1.year)..(time_zone_now.beginning_of_year - 1.second)   
      end  
  end
end
