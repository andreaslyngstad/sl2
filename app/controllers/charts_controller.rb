class ChartsController < ApplicationController
  
  def users_logs
    var_setter(params,:user)
    render :formats => [:json]
  end
  
  def projects_logs
    var_setter(params,:project)
    render :formats => [:json]
  end
  
  def customers_logs   
    var_setter(params,:customer)
    render :formats => [:json]
  end
  
  private
  
  def var_setter(params,model)
    range = params[:form].to_date..params[:to].to_date
    @stacked = ChartData.new(current_firm,range,model).stacked
    @pie = ChartData.new(current_firm,range,model).pie
  end
end