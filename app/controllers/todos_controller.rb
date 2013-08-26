class TodosController < ApplicationController
  def create
    @todo = Todo.new(params[:todo])
    @todo.firm = current_firm
    respond_to do |format|
      if todo.save
        flash[:notice] = flash_helper('Task was successfully created.')
        format.js
      else       
        format.js { render "shared/validate_create" }
      end
    end
  end
  def edit
  end
  def update
    if params[:todo][:completed] == "1"
      todo.done_by_user = current_user 
    else
      todo.done_by_user = nil
    end

    respond_to do |format|
      if todo.update_attributes(params[:todo])
        flash[:notice] = flash_helper('Task was successfully updated.')
        format.js
      else
        format.js { render "shared/validate_update" }
      end
    end
  end

  def destroy
    todo.destroy
    flash[:notice] = flash_helper('Task was successfully deleted.')
    respond_to do |format|
      format.js
    end
  end
  
  def todo
    @todo ||= params[:id] ? Todo.find(params[:id]) : Todo.new(params[:todo])
  end
  helper_method :todo
  
end
