require "devise"
module SubdomainLogin
  def after_sign_in_path_for(resource_or_scope)
    scope = Devise::Mapping.find_scope!(resource_or_scope)
    subdomain_name = current_user.firm.subdomain
    if current_subdomain.nil?
      # logout of root domain and login by token to subdomain
      token =  Devise.friendly_token
      current_user.loginable_token = token
      current_user.save
      sign_out(current_user)
      flash[:notice] = nil
      home_path = valid_user_url(token, :subdomain => subdomain_name)
      return home_path
    else
      if subdomain_name != current_subdomain.name
        # user not part of current_subdomain
        sign_out(current_user)
        flash[:notice] = nil
        flash[:alert] = "Sorry, invalid user or password for subdomain"
      end
    end
    super
  end

  def sign_in_and_redirect(user, firm)
  redirect_to statistics_path(:subdomain => firm.subdomain)
  sign_in(user)
  end
end