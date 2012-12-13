class TabsController < ApplicationController
  def milestones
    @klass = get_klass(params[:class]).find(params[:id])
    @milestones = get_klass(params[:class]).find(params[:id]).milestones.order("due ASC")
  end
  def todos  
    @klass = get_klass(params[:class]).find(params[:id])
    @done_todos = get_klass(params[:class]).find(params[:id]).todos.where(["completed = ?", true]).includes( {:user => [:memberships]}, :logs, :project).order("due ASC")
    @not_done_todos = get_klass(params[:class]).find(params[:id]).todos.where(["completed = ?", false]).includes({:user => [:memberships]}, :logs, :project).order("due ASC") 
     @members = current_firm.users
  end
  def logs
    @klass = get_klass(params[:class]).find(params[:id])
    @logs = @klass.recent_logs.includes([:user, :todo, :employee, {:customer => [:employees]}, {:project => [:customer, :todos]}])
    @all_projects = current_user.projects.where(["active = ?", true])
    @customers = current_firm.customers
  end
  def users
    @klass = get_klass(params[:class]).find(params[:id])
    @users = @klass.users
  end
  private
  def get_klass(params)
    eval(params)
  end
end