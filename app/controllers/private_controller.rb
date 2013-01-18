class PrivateController < ApplicationController


  def account
    authorize! :read, Firm
  end
  
  def statistics
    authorize! :read, Firm
    @log_week = current_firm.logs.where(:log_date => (Time.now.beginning_of_week + 1.second)..(Time.now.end_of_day)).group("date(log_date)").sum(:hours)
 	  @logs_project = current_firm.logs.where(['log_date > ? AND project_id IS NOT ?', Time.now.beginning_of_week, nil]).group("project").sum(:hours) 
    @logs_customer = current_firm.logs.where(['log_date > ? AND customer_id IS NOT ?', Time.now.beginning_of_week, nil]).group("customer").sum(:hours)
    @logs_user = current_firm.logs.where(['log_date > ?', Time.now.beginning_of_week]).group("user").sum(:hours)
  end


  def reports
      authorize! :manage, Firm
  	 @users = current_firm.users
  	 @projects = current_firm.projects
  	 @customers = current_firm.customers
  end
  
  def report_for
  	if !params[:user_id].blank?
  	@user = User.find(params[:user_id])
  	
  	@logs = @user.logs.where(:log_date => (params[:from].to_date + 1.second)..(params[:to].to_date.end_of_day))
  	@projects = @logs.project
  	@logs_hours_by_project = @logs.group("project_id", "date(log_date)")
  	@logs_hours_by_date = @logs.group("date(log_date)").sum(:hours)
  	
  	end
  	if !params[:project_id].blank?
  	@project = Project.find(params[:project_id])
  	end
  	if !params[:customer_id].blank?
  	@customer = Customer.find(params[:customer_id])
  	end
  end
  

  def membership
    
  	@project = Project.find(params[:project_id])
  	authorize! :manage, @project
  	@user = User.find(params[:id])
  	
  	if @project.users.include?(@user)
  		@project.users.delete(@user)
  		flash[:notice] = flash_helper("#{@user.name} is NOT a member of the #{@project.name} project.")
  	else
  		@project.users << @user
  		flash[:notice] = flash_helper("#{@user.name} is a member of the #{@project.name} project.")
  	end
  	
  	@members = @project.users
  	@not_members = current_firm.users - @members	
  end
end

   




