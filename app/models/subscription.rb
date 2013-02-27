class Subscription < ActiveRecord::Base
  attr_accessible :name, :email, :paymill_id, :plan_id, :paymill_card_token,:firm_id
  belongs_to :plan
  belongs_to :firm
  validates_presence_of :plan_id 
  validates_presence_of :firm_id 
  attr_accessor :paymill_card_token
  before_create :update_firm_plan
  
  def save_with_payment
    if valid?
      client = Paymill::Client.create email: email, description: name
      payment = Paymill::Payment.create token: paymill_card_token, client: client.id
      subscription = Paymill::Subscription.create offer: plan.paymill_id, client: client.id, payment: payment.id
      firm = Firm.find(firm_id)
      if subscription
        if plan_id < firm.plan.id
          firm.remove_associations_when_downgrading(plan_id)
        end
        Subscription.delete_old_subscription(firm)
      end
      self.paymill_id = subscription.id
      save!
    end
  rescue Paymill::PaymillError => e
    logger.error "Paymill error while creating customer: #{e.message}"
    errors.add :base, "There was a problem with your credit card. Please try again."
    false
  end
  
  def self.delete_old_subscription(firm)
    if firm.subscription && firm.subscription.paymill_id
      Paymill::Subscription.delete(firm.subscription.paymill_id)
    end
    self.where(firm_id: firm.id).destroy_all 
  end
  
  def update_firm_plan
    self.firm.update_plan(plan_id)
  end
end

