class TodosController < ApplicationController
  def create
    @todo = Todo.new(params[:todo])
    @todo.firm = current_firm
    respond_to do |format|
      if todo.save
        flash[:notice] = flash_helper('Todo was successfully created.')
        format.js
      else       
        format.js { render "shared/validate_create" }
      end
    end
  end
  def edit
  end
  def update
    respond_to do |format|
      if todo.update_attributes(params[:todo])
        flash[:notice] = flash_helper('Todo was successfully updated.')
        format.js
      else
        format.js { render "shared/validate_update" }
      end
    end
  end
  def todos_done
    respond_to do |format|
      if todo.update_attributes(params[:todo])
        flash[:notice] = flash_helper('Todo was successfully updated.')
        format.js
      else
        format.js
      end
    end
  end
  def destroy
    todo.destroy
    @done_todos = todo.project.todos.where(["completed = ?", true]).includes(:user)
    @not_done_todos = todo.project.todos.where(["completed = ?", false]).includes(:user)
    flash[:notice] = flash_helper('Todo was successfully deleted.')
    respond_to do |format|
      format.js
    end
  end
  
  def todo
    @todo ||= params[:id] ? Todo.find(params[:id]) : Todo.new(params[:todo])
  end
  helper_method :todo
  
end
