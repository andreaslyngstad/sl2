module ApplicationHelper
	
  def current_firm
    @current_firm ||= Firm.find_by_subdomain!(request.subdomain)
    # return @current_firm if defined?(@current_firm)
    # @current_firm = current_user.firm
  end
  def date_format(date,options = {} )
    if options[:short]
      if current_firm.date_format == 1
        date.strftime("%d.%m.%y")
      elsif current_firm.date_format == 2 
        date.strftime("%m/%d/%y")
      end
    else
      if current_firm.date_format == 1
        date.strftime("%d.%m.%Y")
      elsif current_firm.date_format == 2 
        date.strftime("%m/%d/%Y")
      end
    end
  end
  def clock_format(time,options = {} )
      if current_firm.clock_format == 1
        time.strftime("%H:%M")
      elsif current_firm.clock_format == 2 
        time.strftime("%I:%M%P")
      end
  end
  
  def all_users
    @all_users ||= current_firm.users.order("name")
  end 
   
  def all_projects
    @all_projects ||= current_user.projects.where(["active = ?", true]).includes(:customer, {:todos => [:logs]})
  end 
   
  def all_customers
    if current_user.role == "External user"
      @all_customers = []
    else
      @all_customers ||= current_firm.customers.order("name")
    end
  end
  
	def truncate_string(text, length = 18, truncate_string = '...')
     if text.nil? then return end
     l = length - truncate_string.length
     text.length > length ? text[0...l] + truncate_string : text
	end

	def image(person, css_class)
		if person.avatar_file_name.nil?
			image_tag("http://www.gravatar.com/avatar/#{Digest::MD5::hexdigest(person.email)}?default=mm&s=100", :alt => 'Avatar', :class => css_class)
		else
			if css_class == "image32"
				image_tag person.avatar.url(:small), :class => css_class
			elsif css_class == "image100" or css_class == "image64"
				image_tag person.avatar.url(:original), :class => css_class	
			end
		end
	end
	def time_diff(time)
  	seconds    	=  (time % 60).to_i
    time 		= (time - seconds) / 60
    minutes    	=  (time % 60).to_i
    time 		= (time - minutes) / 60
    hours      	=  (time).to_i
    if minutes == 0 
    	return hours.to_s + ":00"
    elsif minutes < 10
    	return hours.to_s + ":0" + minutes.to_s
	else
  		return hours.to_s + ":" + minutes.to_s
  	end
  end
	def done_not_done(done_todos, not_done_todos)
  	done = done_todos.count
  	not_done = not_done_todos.count	
  	donepr = (done / (done + not_done).to_f)*100
  	not_donepr = (not_done / (done + not_done).to_f)*100
  	donepr.round(2).to_s + "%"
  end
 	def url_splitter(url)
 		url.split("/").first
 	end	 
 	def url_splitter2(url)
 		url.split("/").third
 	end	
 	def todo_priority(prior)
 	  case
 	  when prior == 3
 	    "todo_red"
 	  when prior == 2
 	    "todo_yellow"
 	  when prior == 1
 	    "todo_green"
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
