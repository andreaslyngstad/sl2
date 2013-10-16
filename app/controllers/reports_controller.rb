class ReportsController < ApplicationController
	def index
     authorize! :read, Firm
     if can? :manage, Firm
  	 @users = current_firm.users
  	 @projects = current_firm.projects
  	 @customers = current_firm.customers
    else
     @users = User.where(id: current_user.id)
     @projects = current_user.projects
     @customers = current_firm.customers
   end
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
        render "squadlink_report", formats: [:csv], handler: [:erb]
      end
      format.xls do
        response.headers['Content-Disposition'] = 'attachment; filename="squadlink_report.xls"'
        render "squadlink_report", formats: [:xls], handler: [:erb]
      end
    end
  end
end   