class UsersController < ApplicationController 

  skip_before_filter :authenticate_user!, :only => [:valid]
  respond_to :html, :js, :json
  def index
    @users = current_firm.users.order(:name)
    respond_with(@users)
  end

  def show
    @klass = User.find(params[:id])
    respond_with(@klass)
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @klass = User.new(params[:user])
    @klass.firm = current_firm 
     respond_to do |format|
      if @klass.save
        flash[:notice] = flash_helper("Registration successful.")
        format.html {redirect_to(users_path())}
        format.js
      else
        flash[:notice] = flash_helper("Something went wrong")
        format.js { render "shared/validate_create" }
    end
    end
  end

  def update
     @klass = User.find(params[:id])
      respond_to do |format|
    if @klass.update_attributes(params[:user])
      flash[:notice] = flash_helper("Successfully updated profile.")
      format.html {redirect_to(user_path(@klass))}
      format.js
    else
      format.js { render "shared/validate_update" }
      flash[:notice] = flash_helper("Something went wrong")
    end
    end
  end

  def destroy
    @user = User.find(params[:id])
     respond_to do |format|
    if @user == current_user
    flash[:notice] = flash_helper("You are logged in as #{@user.name}. You cannot delete yourself.")
      format.html{ redirect_to(users_path())}
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
  
  def valid

  	token_user = User.valid?(params)

    if token_user
      sign_in(:user, token_user)
      flash[:notice] = flash_helper("You have been logged in")
    else
      flash[:alert] = "Login could not be validated"
    end
    redirect_to statistics_path
  end
  
end
