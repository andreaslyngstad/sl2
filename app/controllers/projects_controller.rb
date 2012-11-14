class ProjectsController < ApplicationController
  load_and_authorize_resource :firm
	
  def index
  	@firm = current_firm
  	#make admin veiw all projects
    @projects = current_user.projects.is_active
    @customers = @firm.customers
    @project = Project.new
    @todo = Todo.new
  end
  def archive
  
  	@projects = current_firm.projects.is_inactive
  	
  end
  
  def activate_projects
    @project = Project.find(params[:id])
      if @project.active == true
        @project.active = false
        flash[:notice] = flash_helper("Project is made inactive.")
      else
        @project.active = true
        flash[:notice] = flash_helper("Project is made active.")
      end  
    
    respond_to do |format|
      if @project.save
      format.js
      end
      end
  end

  def show
  	@user = current_user
    @project = current_firm.projects.find(params[:id])
    @users = @project.users
    @milestone = Milestone.new(:project => @project)
    @milestones = @project.milestones.order("due ASC")
    @todo = Todo.new(:project => @project)
    @done_todos = @project.todos.where(["completed = ?", true]).includes( {:user => [:memberships]}).order("due ASC")
    @not_done_todos = @project.todos.where(["completed = ?", false]).includes({:user => [:memberships]}).order("due ASC")
    @hours = @project.logs.sum(:hours)
    
    @firm = current_user.firm
    @customers = @firm.customers.includes(:employees)
    @log = Log.new(:project => @project)
    @logs = @project.recent_logs.includes([:user, :todo, :employee, {:customer => [:employees]}, {:project => [:customer, :todos]}])
    @all_projects = current_user.projects.where(["active = ?", true])
    @todos = @project.todos.where(["completed = ?", false]).includes(:user)
    
    @members = @project.users
    @not_members = @firm.users - @members
  end

  def create
    @project = Project.new(params[:project])
    @project.firm = current_firm
    @project.active = true
    @project.users << current_user
   
      respond_to do |format|
      if @project.save
      flash[:notice] = flash_helper("Project is added.")
      format.js
      end
      end
  end
  
  def update
  	@firm = current_firm
    @project = Project.find(params[:id])
    @customers = @firm.customers
    respond_to do |format|
      if @project.update_attributes(params[:project])
        flash[:notice] = flash_helper("Project was successfully saved.")
        format.js
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def destroy
   @project = Project.find(params[:id])
   @project.destroy
    
    respond_to do |format|
      flash[:notice] = flash_helper('Project was deleted.')
      format.html { redirect_to projects_path }
      format.js
    end
  end
end
