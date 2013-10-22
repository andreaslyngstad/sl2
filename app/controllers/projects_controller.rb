class ProjectsController < ApplicationController
   
  def index
    if current_user.role == "External user"
      @projects = current_user.projects.includes(:firm)
    else
      @projects = current_firm.projects.where(:active => true).includes(:firm).order_by_name
    end

  end
  def edit
    @project = Project.find(params[:id]) 
    authorize! :manage, @project
    @customers = current_firm.customers
    respond_to do |format|
        format.js
    end
  end
  

  def show
    @klass = current_firm.projects.find(params[:id]) 
    authorize! :manage, @klass
    @hours = @klass.logs.sum(:hours)
    @done_todos = @klass.todos.where(["completed = ?", true]).includes( {:user => [:memberships]}).order("due ASC")
    @not_done_todos = @klass.todos.where(["completed = ?", false]).includes({:user => [:memberships]}).order("due ASC") 
    @members = @klass.users
    @not_members = all_users - @members
  end

  def create
    
    @klass = current_firm.projects.new(permitted_params.project)
    @klass.active = true
    @klass.users << current_user
    authorize! :manage, @klass
    respond_to do |format|
      if @klass.save
        flash[:notice] = flash_helper("Project is added.")
        format.js
      else
        format.js { render "shared/validate_create" }
      end
    end
    
  end
  
  def update
    @klass = Project.find(params[:id])
    @klass.firm = current_firm
    respond_to do |format|
      if @klass.update_attributes(permitted_params.project)
        flash[:notice] = flash_helper("Project was successfully saved.")
        format.js
      else
        format.js { render "shared/validate_update" }
       
      end
    end
    
  end
  
  def destroy
    authorize! :archive, Firm
   @klass = Project.find(params[:id])
   
   @klass.destroy
    respond_to do |format|
      flash[:notice] = flash_helper('Project was deleted.')
      format.js
    end
  end
  
  def archive 
    @projects = current_firm.projects.where(:active => false).order("name ASC")  
  end
  
  def activate_projects
    @project = Project.find(params[:id])
    authorize! :archive,  @project
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
 
end
