class MilestonesController < ApplicationController
  def create
    @milestone = Milestone.new(params[:milestone])
    respond_to do |format|
      if @milestone.save
        flash[:notice] = flash_helper('Milestone was successfully created.')
        format.js { render :action => "create_success"}
        else
        format.xml  { render :xml => @log.errors, :status => :unprocessable_entity }
        format.js { render :action => "failure"}
      end
     end
  end
  
  def update
    @milestone = Milestone.find(params[:id])
    if @milestone.update_attributes(params[:milestone])
      flash[:notice] = flash_helper('Milestone was successfully updated.')
      respond_to do |format|
        format.js
      end
    else
      respond_to do |format|
        format.json { render :nothing =>  true }
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
