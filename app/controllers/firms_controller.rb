class FirmsController < ApplicationController
  authorize_resource :firm
  
  skip_before_filter :authenticate_user!
  

  def show 
    @firm = Firm.find_by_subdomain!(request.subdomain)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @firm }
      format.js
    end
  end

  def firm_edit
    @firm = current_firm
  end
  def firm_update
    @firm = current_firm
    respond_to do |format|
      if @firm.update_attributes(params[:firm])
        flash[:notice] = flash_helper('Account was successfully updated.')
        format.html { redirect_to account_path }
        format.xml  { head :ok }
      else
        flash[:error] = 'Firm could not be updated'
        format.html { render :action => "firm_edit" }
        format.xml  { render :xml => @firm.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @firm = Firm.find(params[:id])
    @firm.destroy

    respond_to do |format|
      format.html { redirect_to(firms_url) }
      format.xml  { head :ok }
    end
  end
  
end
