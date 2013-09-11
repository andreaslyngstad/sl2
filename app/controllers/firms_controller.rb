class FirmsController < ApplicationController
  def firm_show 
    authorize! :read, Firm
  end

  def firm_edit
    authorize! :manage, Firm
  end
  def firm_update
    @firm = current_firm
    respond_to do |format|
      if @firm.update_attributes(permitted_params.firm)
        flash[:notice] = flash_helper('Account was successfully updated.')
        format.html { redirect_to firm_show_path }
      else
        flash[:error] = 'Firm could not be updated'
        format.html { render :action => "firm_edit" }
      end
    end
  end

  def destroy
    authorize! :manage, Firm
    @firm = Firm.find(params[:id])
    @firm.destroy
    flash[:notice] = "Your firm and all data are deleted from our servers. You are always welcome back. Thanks!"
    redirect_to(root_url(:subdomain => nil)) 
  end
end
