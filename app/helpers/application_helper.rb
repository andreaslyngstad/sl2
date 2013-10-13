module ApplicationHelper
  def current_firm
    @current_firm ||= Firm.find_by_subdomain!(request.subdomain)
   
  # return @current_firm if defined?(@current_firm)
  # @current_firm = current_user.firm
  end

  def all_users
    @all_users ||= current_firm.users.order("name")
  end 
   
  def all_projects
    @all_projects ||= current_user.projects.where(["active = ?", true])
  end 
   
  def all_customers
    if current_user.role == "External user"
      @all_customers = []
    else
      @all_customers ||= current_firm.customers.order("name")
    end
  end
  
  def time_zone_now
    #exchange for Time.now
    Time.zone = current_firm.time_zone
    return Time.now.in_time_zone
  end

	def truncate_string(text, length = 18, truncate_string = '...')
     if text.nil? then return end
     l = length - truncate_string.length
     text.length > length ? text[0...l] + truncate_string : text
	end

	def image(person, css_class)
		if person.avatar_file_name.nil?
			 image_tag("https://secure.gravatar.com/avatar/#{Digest::MD5::hexdigest(person.email)}?default=mm&s=100", :alt => 'Avatar', :class => css_class)
		else
			if css_class == "image32"
				image_tag person.avatar.url(:small), :class => css_class
			elsif css_class == "image100" or css_class == "image64"
				image_tag person.avatar.url(:original), :class => css_class	
			end
		end
	end

  #for devise
  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
  
  def prices_to_currency(price)
    number_to_currency price, unit: "$", strip_insignificant_zeros: true
  end
end
