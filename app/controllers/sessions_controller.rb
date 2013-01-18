class SessionsController < Devise::SessionsController
  skip_before_filter :authenticate_user!, :all_users
  def new
    resource = build_resource
    clean_up_passwords(resource)
    respond_with(resource, serialize_options(resource))
  end
  def create
    
    subdomain = request.subdomain
    resource = warden.authenticate!(auth_options)
   if subdomain.present? && resource.firm.subdomain == subdomain || subdomain == "www"
     set_flash_message(:notice, :signed_in) if is_navigational_format?
     redirect_to root_url(:subdomain => resource.firm.subdomain )
     sign_in(resource_name, resource)
   else
      sign_out_and_redirect_with_token(resource)
   end
  end
  
  def destroy
    current_user.current_sign_in_at = nil
    current_user.save
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    set_flash_message :notice, :signed_out if signed_out
    redirect_to root_url(:subdomain => nil)
  end

  def sign_in_at_subdomain
      token_user = User.valid_recover?(cookies[:token].to_s)
      cookies.delete(:token, :domain => :all)
    if token_user
       sign_in(token_user)
       flash[:notice] = "Signed in successfully"
      redirect_to root_url(:subdomain => token_user.firm.subdomain )
    else
      flash[:alert] = "Login could not be validated"
      redirect_to root_url
    end
  end
private
  def sign_out_and_redirect_with_token(resource)
     sign_out(resource)
     token =  Devise.friendly_token
     resource.loginable_token = token
     resource.save
     cookies[:token] = { :value => token, :domain => :all }
     redirect_to sign_in_at_subdomain_url( :subdomain => resource.firm.subdomain)
  end
end