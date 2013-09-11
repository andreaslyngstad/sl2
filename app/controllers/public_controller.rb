require "subdomain_login" 
class PublicController < ApplicationController
  skip_before_filter :authenticate_user!, :all_users, :user_at_current_firm
  layout "registration"
  respond_to :html
  include SubdomainLogin
  def index
  end

  def register
    @firm = Firm.new   
  end 
  
  def first_user
    @firm = Firm.find(params[:firm_id])
    @user = @firm.users.build
  end
  
  def create_firm  
    @firm = Firm.new(permitted_params.firm)
    @firm.subdomain = @firm.subdomain.downcase
    respond_to do |format|
      if @firm.save
        flash[:notice] = 'Firm was successfully created! Now create the first user.'
        format.html { redirect_to(register_user_path(@firm)) }    
      else
        flash[:error] = 'Firm could not be created'
        format.html { render action:'register', :layout => "registration"}
        format.xml  { render :xml => @firm.errors, :status => :unprocessable_entity }
      end
    end
  end

  def create_first_user
    @firm = Firm.find(params[:firm_id])
    @user = @firm.users.new(permitted_params.first_user)
    @user.role = "Admin"
    

        if @user.save
          flash[:notice] = "Registration successful."
          FirmMailer.sign_up_confirmation(@user).deliver
          sign_in(@user)
          sign_out_and_redirect_with_token(@user)
        else
        	flash[:error] = "Registration could not be saved."
          render :action => 'first_user'
      end
  end
  def validates_uniqe
    if !params[:subdomain].to_s.match(/^[a-z0-9]+$/i).nil?
  	 @firm = Firm.find_by_subdomain(params[:subdomain])
  	else
  	 @wrong_format = true
  	end
  end	
  def termsofservice
  end
  def pricing
    @plans = Plan.all
  end
  def contact
  end

end
