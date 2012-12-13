class PublicController < ApplicationController
  skip_before_filter :authenticate_user!, :all_users
  layout "registration"
  respond_to :html

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
    @firm = Firm.new(params[:firm])
    @firm.subdomain = @firm.subdomain.downcase
    respond_to do |format|
      if @firm.save
        flash[:notice] = 'Firm was successfully created! Now create the first user.'
        format.html { redirect_to(register_user_path(@firm)) }
        
      else
        flash[:error] = 'Firm could not be created'
        format.html { render "public/register", :layout => "registration"}
        format.xml  { render :xml => @firm.errors, :status => :unprocessable_entity }
      end
    end
  end

  def create_first_user
    @user = User.new(params[:user])
    @firm = Firm.find(params[:firm_id])
    @user.role = "Admin"
    @user.firm = @firm

        if @user.save
          flash[:notice] = "Registration successful."
          sign_in(@user)
          respond_with @user, :location => after_sign_in_path_for(@user)
        else
        	flash[:error] = "Registration could not be saved because:"
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
end
