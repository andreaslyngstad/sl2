class PlansController < ApplicationController
  def index
  	authorize! :manage, Firm
    @plans = Plan.order("price")
  end
  def cancel
  	authorize! :manage, Firm
    @plan = current_firm.plan
  end
end
