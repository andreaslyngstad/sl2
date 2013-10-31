class UsersController < ApplicationController 
  
  skip_before_filter :authenticate_user!, :only => [:valid]
  respond_to :html, :js, :json
  def index
    authorize! :read, User
    @users = current_firm.users.order(:name).includes(:firm)
    respond_with(@users)
  end

  def show  
    @klass = current_firm.users.find(params[:id])
    authorize! :read, @klass
    respond_with(@klass)
  end

  def edit
    authorize! :manage, User
    @user = current_firm.users.find(params[:id])
  end

  def create
    @klass = current_firm.users.new(permitted_params.user)
    authorize! :manage, User
    @klass.firm = current_firm 
     respond_to do |format|
      if @klass.save
        flash[:notice] = flash_helper("Registration successful.")
        format.js
        $customerio.identify(
           id: @klass.id,
           email: @klass.email,
           created_at: @klass.created_at.to_i,
           name: @klass.name,
           firm: @klass.firm.name,
           firm_subdomain: @klass.firm.subdomain,
           subscription: @klass.firm.subscription.name,
           send_welcome_email: params[:send_welcome_email]
        ) 
      else
        format.js { render "shared/validate_create" }
    end
    end
  end

  def update
    if params[:user][:password].blank?
      params[:user].delete("password")
      params[:user].delete("password_confirmation")
    end
     @klass = current_firm.users.find(params[:id])
     authorize! :update, @klass
      respond_to do |format|
    if @klass.update_attributes(permitted_params.user)
      flash[:notice] = flash_helper("Successfully updated profile.")
      format.js
      format.html { redirect_to user_path(@klass) }
    else
      
      format.html
      format.js { render "shared/validate_update" }
      
    end
    end
  end

  def destroy
   
    @user = current_firm.users.find(params[:id])
    authorize! :manage, @user
     respond_to do |format|
    if @user == current_user
    flash[:notice] = flash_helper("You are logged in as #{@user.name}. You cannot delete yourself.")
      format.js
    else
    @user.destroy
   		flash[:notice] = flash_helper("#{@user.name} was deleted.")
      format.html { redirect_to(users_url()) }
      format.xml  { head :ok }
      format.js
    end
    end
  end
  
  # def valid
  # 	token_user = User.valid?(params)
  #   if token_user
  #     sign_in(:user, token_user)
  #     flash[:notice] = flash_helper("You have been logged in")
  #   else
  #     flash[:alert] = "Login could not be validated"
  #   end
  #   redirect_to statistics_path
  # end 
end
