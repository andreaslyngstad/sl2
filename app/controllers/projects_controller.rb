class ProjectsController < ApplicationController
  def index
  end
  def edit
    @project = Project.find(params[:id])
    @customers = current_firm.customers
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
    @klass = current_firm.projects.find(params[:id])
    @hours = @klass.logs.sum(:hours)
    @done_todos = @klass.todos.where(["completed = ?", true]).includes( {:user => [:memberships]}).order("due ASC")
    @not_done_todos = @klass.todos.where(["completed = ?", false]).includes({:user => [:memberships]}).order("due ASC") 
    @members = @klass.users
    @not_members = all_users - @members
  end

  def create
    @project = Project.new(params[:project])
    @project.active = true
    @project.firm = current_firm
    @project.users << current_user
      respond_to do |format|
      if @project.save
      flash[:notice] = flash_helper("Project is added.")
      format.js
      end
      end
  end
  
  def update
    @project = Project.find(params[:id])
    @project.firm = current_firm
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
