class PlansController < ApplicationController
  def index
    @plans = Plan.order("price")
  end
  def cancel
    @plan = current_firm.plan
  end
end
