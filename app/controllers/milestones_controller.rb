class MilestonesController < ApplicationController
  def create
    @milestone = Milestone.new(permitted_params.milestone)
    @milestone.firm = current_firm
    respond_to do |format|
      if @milestone.save
        flash[:notice] = flash_helper('Milestone was successfully created.')
        format.js { render :action => "create_success"}
        else
        format.js { render :action => "failure"}
      end
     end
  end
  
  def update
    @milestone = Milestone.find(params[:id])
    @milestone.firm = current_firm
    if @milestone.update_attributes(permitted_params.milestone)
      flash[:notice] = flash_helper('Milestone was successfully updated.')
      respond_to do |format|
        format.js
      end
    else
      respond_to do |format|
        format.js
      end
    end
  end

  def destroy
    @milestone = Milestone.find(params[:id])
    @milestone.destroy   
    respond_to do |format|
      flash[:notice] = flash_helper('Milestone was successfully deleted.')
      format.js
    end
  end
end
