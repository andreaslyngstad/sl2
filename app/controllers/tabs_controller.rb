class TabsController < ApplicationController
  respond_to :js
  def tabs_state
    get_instance(params)
    if params[:class] == "Invoice"
      @logs = @klass.logs.order(:log_date).includes(:user, :project, :todo, :customer, :employee)
    else
      @logs = @klass.logs.order("log_date DESC").limit(3).includes(:user)
    end
  end
  def tabs_milestones
    get_instance(params)
    @milestones = @klass.milestones.order("due ASC").includes(:project)
    respond_with(@milestones)
  end 
  def tabs_todos  
    time_range = (Time.now.midnight - 7.day)..(Time.now.midnight + 7.day)
    get_instance(params)
    @done_todos = get_klass(params[:class]).find(params[:id]).todos.where(["completed = ?", true]).where(:due => time_range).includes( :user, :done_by_user, :logs, :project,:customer).order("due ASC")
    @not_done_todos = get_klass(params[:class]).find(params[:id]).todos.where(["completed = ?", false]).where(:due => time_range).includes(:user, :done_by_user, :logs, :project,:customer).order("due ASC") 
    @members = current_firm.users
    respond_with( @done_todos, @not_done_todos, @members)
  end
  def tabs_logs
    get_instance(params)
    @logs = @klass.recent_logs.includes([:user, :todo, :employee, :customer, :firm,{:project => [:firm]}])
    respond_with( @logs)
  end
  def tabs_users
    get_instance(params)
    @members = @klass.users
    @not_members = all_users - @members
    respond_with(@members)
  end
  def tabs_statistics
    get_instance(params)
    @logs = @klass.recent_logs.includes([:user, :todo, :employee, :customer, {:project => [:firm]}])
    respond_with( @logs)
  end
  def tabs_spendings
    get_instance(params)
    @users = @klass.users
    @logs = @klass.recent_logs.includes([:user, :todo, :employee, :customer, {:project => [:firm]}])
    respond_with(@logs, @users)
  end
  def tabs_projects
    get_instance(params)
    @project = current_firm.projects.new
    @projects = @klass.projects.where(:active => true)
    respond_with(@projects)
  end
  def tabs_employees
    get_instance(params)
    @employees = @klass.employees
    respond_with(@employees)
  end
  def tabs_invoices
    get_instance(params)
    @invoices = @klass.invoices
    @logs = @klass.logs.where(invoice_id: nil)
    # @logs = current_firm.logs
    respond_with(@invoices)
  end
  private
  def get_instance(params)
    @klass = get_klass(params[:class]).find(params[:id])
  end
  def get_klass(params)
    eval(params)
  end
end