class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
  require "./lib/timehelp"
	include UrlHelper
	include SubdomainLogin
	
  before_filter :set_mailer_url_options, :all_users,
  :authenticate_user!, 
  :exept => [:after_sign_in_path_for, :sign_in_and_redirect, :check_firm_id, :current_subdomain]
  helper :layout
  helper_method :current_firm, :is_root_domain?, :can_sign_up?, :current_subdomain, :time_zone_now, :ftz, :time_range_to_day
  # skip_before_filter :find_firm, :only => [:sign_up_and_redirect]

  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  
  
  rescue_from CanCan::AccessDenied do |exception|
  flash[:error] = flash_helper("Sorry. You do not have access to this url. Please contact the site admin")
  redirect_to root_path()
  end
  
  def can_sign_up?
    # return true if config.allow_account_sign_up is set to true
  	# Used in conjection with is_root_domain? for root domain.
    is_root_domain? ? true :Account::CAN_SIGN_UP
  end
  
  def current_subdomain
      if request.subdomains.first.present? && request.subdomains.first != "www"
        current_subdomain = Firm.find_by_subdomain(request.subdomains.first)
      else
        current_subdomain = nil
      end
      return current_subdomain
  end
  
  
  
  def not_found
      raise ActionController::RoutingError.new('Not Found')
  end
  
  def flash_helper(message)
  	return ("<span style='color:#FFF'>" + message + "</span>").html_safe
  end 
  
  def time_zone_now
  	#exchange for Time.now
  	Time.zone = current_firm.time_zone
  	return Time.now.in_time_zone
  end
  
  def ftz(time)
	time.in_time_zone(current_firm.time_zone)
  end
  def current_firm
    @current_firm ||= Firm.find_by_subdomain!(request.subdomain)
    # return @current_firm if defined?(@current_firm)
    # @current_firm = current_user.firm
  end
  def all_users
    @all_users ||= current_firm.users.order("name")
  end  
  def all_projects
    @all_projects ||= current_user.projects.where(["active = ?", true]).includes(:customer, {:todos => [:logs]})
  end  
  private

  def check_firm_id
    return current_subdomain ? current_user.firm.id == current_subdomain.id : false
  end
  def time_range_to_day
  	Time.zone.today
  end
  
  def check_log_status(params_log_id)
    if params_log_id != "0"
    @log = Log.find(params_log_id)
    end
    @customers = current_firm.customers
  end
  def record_not_found
    flash[:notice] = "No record found"
    redirect_to action: :index
  end
end
