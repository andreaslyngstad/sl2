class SubscriptionsController < ApplicationController
  
  def new
    @plan = Plan.find(params[:plan_id])
    @subscription = @plan.subscriptions.build
  end

  def create
    @subscription = Subscription.new(params[:subscription])
    @plan = @subscription.plan
    @subscription.firm_id = current_firm.id
    if @subscription.save_with_payment
      redirect_to plans_path, :notice => "Thank you for subscribing!"
    else
      render :new
    end
  end

  def show
    @subscription = Subscription.find(params[:id])
  end
  
  def destroy
    @subscription = Subscription.find(params[:id])
    firm = @subscription.firm
    firm.plan = Plan.free
    @subscription.destroy
  end
end
