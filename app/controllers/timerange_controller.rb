class TimerangeController < ApplicationController
  def timerange(time)
    if time == "to_day"
      time_range = (Time.now.midnight)..(Time.now.midnight + 1.day)
      elsif time == "this_week"
      time_range = (Time.now.beginning_of_week)..(Time.now.end_of_week)   
      elsif time == "this_month"
      time_range = (Time.now.beginning_of_month)..(Time.now.end_of_month)   
      elsif time == "this_year"
      time_range = (Time.now.beginning_of_year)..(Time.now.end_of_year)   
      elsif time == "yesterday"
      time_range = (Time.now.midnight - 1.day)..(Time.now.midnight - 1.second)   
      elsif time == "last_week"
      time_range = (Time.now.beginning_of_week - 7.day)..(Time.now.beginning_of_week - 1.second)   
      elsif time == "last_month"
      time_range = (Time.now.beginning_of_month - 1.month)..(Time.now.beginning_of_month - 1.second)   
      elsif time == "last_year"
      time_range = (Time.now.beginning_of_year - 1.year)..(Time.now.beginning_of_year - 1.second)   
      end  
  end
  
  def logs_pr_date
    @customers = current_firm.customers
    @all_projects = current_user.projects.where(["active = ?", true]).includes(:customer, {:todos => [:logs]}) 
    find_logs_on(params[:url], timerange(params[:time])) 
    respond_to do |format|
      format.js { render :action => "log_range" }
    end
  end
  
  def log_range
    @customers = current_firm.customers.includes(:employees)
    @all_projects = current_user.projects.where(["active = ?", true]).includes(:customer, {:todos => [:logs]})
    time_range = ((Date.parse(params[:from]).midnight - 1.day)..Date.parse(params[:to]).midnight)
    find_logs_on(params[:url], time_range)
  end
  
  def todos_pr_date
    @range = "range"
    @klass = eval(params[:url]).find(params[:id])
    find_todos_on(params[:url], timerange(params[:time]))
    render :template => 'tabs/todos'
  end
  
  def todo_range
    @range = "range"
    @klass = eval(params[:url]).find(params[:id])
    time_range = ((Date.parse(params[:from]).midnight - 1.day)..Date.parse(params[:to]).midnight)
    find_todos_on(params[:url],time_range)
     render :template => 'tabs/todos'
  end
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
end
