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
    current_firm.remove_associations_when_downgrading(1)
    Subscription.delete_old_subscription(current_firm)
    current_firm.plan = Plan.find(1)
    s = Subscription.new(plan_id: 1)
    s.firm = current_firm
    s.save!
    current_firm.save
    flash[:notice] = flash_helper("You are now on the free plan.")  
    redirect_to plans_path
  end
end
