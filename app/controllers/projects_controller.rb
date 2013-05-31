class ProjectsController < ApplicationController
   
  def index
    if current_user.role == "External user"
      @projects = current_user.projects.includes(:firm)
    else
      @projects = current_firm.projects.where(:active => true).order_by_name.includes(:firm)
    end
  end
  def edit
    @project = Project.find(params[:id])
    
    @customers = current_firm.customers
  end
  

  def show
    @klass = current_firm.projects.find(params[:id])
    @hours = @klass.logs.sum(:hours)
    @done_todos = @klass.todos.where(["completed = ?", true]).includes( {:user => [:memberships]}).order("due ASC")
    @not_done_todos = @klass.todos.where(["completed = ?", false]).includes({:user => [:memberships]}).order("due ASC") 
    @members = @klass.users
    @not_members = all_users - @members
    
  end

  def create
    @klass = current_firm.projects.new(params[:project])
    @klass.active = true
    @klass.users << current_user

    respond_to do |format|
      if @klass.save
        flash[:notice] = flash_helper("Project is added.")
        format.js
      else
        flash[:notice] = flash_helper("Something went wrong")
        format.js { render "shared/validate_create" }
      end
    end
    
  end
  
  def update
    @klass = Project.find(params[:id])
    @klass.firm = current_firm
    respond_to do |format|
      if @klass.update_attributes(params[:project])
        flash[:notice] = flash_helper("Project was successfully saved.")
        format.js
      else
        format.js { render "shared/validate_update" }
        flash[:notice] = flash_helper("Something went wrong")
      end
    end
    
  end
  
  def destroy
   @klass = Project.find(params[:id])
   @klass.destroy
    respond_to do |format|
      flash[:notice] = flash_helper('Project was deleted.')
      format.html { redirect_to projects_path }
      format.js
    end
  end
  
  def archive 
    @projects = current_firm.projects.where(:active => false).order("name ASC")  
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
end
