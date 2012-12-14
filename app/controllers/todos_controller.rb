class TodosController < ApplicationController
  def create
    @todo = Todo.new(params[:todo])
    @todo.completed = false
    respond_to do |format|
      if @todo.save
        flash[:notice] = flash_helper('Todo was successfully created.')
        format.js
      else       
        format.js
      end
    end
  end
 
  def update
    @todo = Todo.find(params[:id])
    respond_to do |format|
      if @todo.update_attributes(params[:todo])
        flash[:notice] = flash_helper('Todo was successfully updated.')
        format.js
      else
        format.js
      end
    end
  end
  def todos_done
    @todo = Todo.find(params[:id])
    respond_to do |format|
      if @todo.update_attributes(params[:todo])
        flash[:notice] = flash_helper('Todo was successfully updated.')
        format.js
      else
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
  def mark_todo_done
    @firm = current_user.firm
    @todo = Todo.find(params[:id])
    @project = @todo.project
    @customers = @firm.customers
    @user = @todo.user
    if @todo.completed == true
      @todo.done_by_user = current_user
      @todo.completed = false
    else
      @todo.done_by_user = nil
      @todo.completed = true
    end
    @todo.save
    if @project
    @done_todos = @project.todos.where(["completed = ?", true]).includes(:user)
    @not_done_todos = @project.todos.where(["completed = ?", false]).includes(:user)
    end
    if @user
    @done_todos = @user.todos.where(["completed = ?", true])
    @not_done_todos = @user.todos.where(["completed = ?", false])
    end    
    respond_to do |format|
      format.js
    end
  end
  
end
