class TimerangeController < ApplicationController
  respond_to :js
  def log_range
    @customers = current_firm.customers.includes(:employees)
    @all_projects = current_user.projects.where(["active = ?", true]).includes(:customer, {:todos => [:logs]})
    find_logs_on(params[:url], get_time_range(params))
    respond_with( @logs)
  end
  
  def todo_range
    @range = "range"
    @klass = eval(params[:url]).find(params[:id])
    find_todos_on(params[:url],get_time_range(params))
    render :template => 'tabs/tabs_todos'
  end

  def invoice_range

  end
  private

  def get_time_range(params)
    if params[:from]
      ((Date.parse(params[:from]).midnight + 1.day)..Date.parse(params[:to]).midnight + 1.day)
    else
      timerange(params[:time])
    end
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

  def find_invoices_on(url, time_range)
    if url == "index"
      invoices_on = current_firm 
    else
      invoices_on = eval(url).find(params[:id])
    end
    @invoices = invoices_on.invoices.where(:due => time_range).order("due DESC").includes(:project, :logs, :customer, :firm )
  end

  def timerange(time)
    case time
      when "to_day"     then (time_zone_now.midnight)..(time_zone_now.midnight + 1.day)
      when "this_week"  then (time_zone_now.beginning_of_week)..(time_zone_now.end_of_week)
      when "this_month" then (time_zone_now.beginning_of_month)..(time_zone_now.end_of_month) 
      when "this_year"  then (time_zone_now.beginning_of_year)..(time_zone_now.end_of_year)
      when "yesterday"  then (time_zone_now.midnight - 1.day)..(time_zone_now.midnight - 1.second) 
      when "last_week"  then (time_zone_now.beginning_of_week - 7.day)..(time_zone_now.beginning_of_week - 1.second) 
      when "last_month" then (time_zone_now.beginning_of_month - 1.month)..(time_zone_now.beginning_of_month - 1.second)
      when "last_year"  then (time_zone_now.beginning_of_year - 1.year)..(time_zone_now.beginning_of_year - 1.second)
      end  
  end
end
