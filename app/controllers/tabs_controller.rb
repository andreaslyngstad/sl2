class TabsController < ApplicationController
  def milestones
    @klass = get_klass(params[:class]).find(params[:id])
    @milestones = get_klass(params[:class]).find(params[:id]).milestones.order("due ASC").includes(:project)
  end
  def todos  
    time_range = (Time.now.midnight - 7.day)..(Time.now.midnight + 7.day)
    @klass = get_klass(params[:class]).find(params[:id])
    @done_todos = get_klass(params[:class]).find(params[:id]).todos.where(["completed = ?", true]).where(:due => time_range).includes( :user, :logs, :project,:customer).order("due ASC")
    @not_done_todos = get_klass(params[:class]).find(params[:id]).todos.where(["completed = ?", false]).where(:due => time_range).includes(:user, :logs, :project,:customer).order("due ASC") 
     @members = current_firm.users
  end
  def logs
    @klass = get_klass(params[:class]).find(params[:id])
    @logs = @klass.recent_logs.includes([:user, :todo, :employee, :customer, {:project => [:firm]}])
  end
  def users
    @klass = get_klass(params[:class]).find(params[:id])
    @users = @klass.users
  end
  def statistics
    @klass = get_klass(params[:class]).find(params[:id])
    @logs = @klass.recent_logs.includes([:user, :todo, :employee, :customer, {:project => [:firm]}])
  end
  private
  def get_klass(params)
    eval(params)
  end
end