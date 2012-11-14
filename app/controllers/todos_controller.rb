class TodosController < ApplicationController
  def create
    @todo = Todo.new(params[:todo])
    @project = @todo.project
    @user = @todo.user
    @todo.completed = false
    if @project
    @done_todos = @project.todos.where(["completed = ?", true]).includes(:user)
    @not_done_todos = @project.todos.where(["completed = ?", false]).includes(:user)
    @todo_same_day = @project.todos.where(:due => @todo.due).first
    else
    @done_todos = @user.todos.where(["completed = ?", true])
    @not_done_todos = @user.todos.where(["completed = ?", false])
    @todo_same_day = @user.todos.where(:due => @todo.due).first 
    end
    
    respond_to do |format|
      if @todo.save
        flash[:notice] = flash_helper('Todo was successfully created.')
        format.xml  { render :xml => @todo, :status => :created, :location => @todo }
        format.js
      else
        format.xml  { render :xml => @todo.errors, :status => :unprocessable_entity }
        format.js
      end
    end
  end
 
  def update
    @todo = Todo.find(params[:id])
    respond_to do |format|
      if @todo.update_attributes(params[:todo])
        flash[:notice] = flash_helper('Todo was successfully updated.')
        format.xml  { head :ok }
        format.js
      else
        format.xml  { render :xml => @todo.errors, :status => :unprocessable_entity }
        format.js
      end
    end
  end

  def destroy
    @todo = Todo.find(params[:id])
    @todo.destroy
    @project = @todo.project
    @firm = @todo.project.firm
    @done_todos = @project.todos.where(["completed = ?", true]).includes(:user)
    @not_done_todos = @project.todos.where(["completed = ?", false]).includes(:user)
    flash[:notice] = flash_helper('Todo was successfully deleted.')
    respond_to do |format|
      format.js
    end
  end
  
  
end
