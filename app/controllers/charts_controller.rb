class ChartsController < ApplicationController
  def admin_firms_chart
    @firm = Firm.count_by_subscription
  end
  
  def users_logs  
    var_setter(params,:user)
  end
  
  def projects_logs
    var_setter(params,:project)
  end
  
  def customers_logs   
    var_setter(params,:customer)
  end
  
  def project_users_logs
    tabs_var_setter(params,:user)
  end
  def project_todos_logs
    tabs_var_setter(params,:todo) 
  end
  def customer_users_logs
    tabs_var_setter(params,:project) 
  end

  private
  def tabs_var_setter(params,model)
    range = params[:from].to_date..params[:to].to_date
    instance = params[:klass].constantize.find(params[:id])
    @stacked = ChartData.new(instance,range,model).stacked
    @pie = ChartData.new(instance,range,model).pie
    render :formats => [:json] 
  end
  
  def var_setter(params,model)
    range = params[:from].to_date..params[:to].to_date
    @stacked = ChartData.new(current_firm,range,model).stacked
    @pie = ChartData.new(current_firm,range,model).pie
    render :formats => [:json] 
  end
end