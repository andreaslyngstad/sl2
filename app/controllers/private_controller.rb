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
  
  def squadlink_report
    range = (params[:from].to_date..params[:to].to_date)
  	@logs = current_firm.logs
  	                    .where(log_date: range)
  	                    .order(:log_date)
  	                    .includes(:user, :project, :customer)
  	                    .try_find_logs(user_id: params[:user_id],
                                       project_id: params[:project_id], 
                                       customer_id: params[:customer_id])
                        
    respond_to do |format|
      format.html
      format.csv do
        response.headers['Content-Disposition'] = 'attachment; filename="squadlink_report.csv"'
        render "squadlink_report.csv.erb"
      end
      format.xls do
        response.headers['Content-Disposition'] = 'attachment; filename="squadlink_report.xls"'
        render "squadlink_report.xls.erb"
      end
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

   




