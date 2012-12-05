class ChartsController < ApplicationController
  
  def users_logs
    range = 3.weeks.ago.to_date..Date.today
    var_setter(range,:user)
    render :formats => [:json]
  end
  
  def projects_logs
    range = 3.weeks.ago.to_date..Date.today
    var_setter(range,:project)
    render :formats => [:json]
  end
  
  def customers_logs
    range = 3.weeks.ago.to_date..Date.today
    var_setter(range,:customer)
    render :formats => [:json]
  end
  
  private
  
  def var_setter(range,model)
    @stacked = ChartData.new(current_firm,range,model).stacked
    @pie = ChartData.new(current_firm,range,model).pie
  end
end