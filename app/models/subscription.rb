class Subscription < ActiveRecord::Base
  attr_accessible :name, :email, :paymill_id, :paymill_card_token, :plan_id,:firm_id, :plan, :firm 
  belongs_to :plan
  belongs_to :firm
  validates_presence_of :plan_id 
  validates_presence_of :firm_id 
  
  attr_accessor :paymill_card_token
  after_create :update_firm_plan
  
  def save_with_payment
    if valid?
      client = Paymill::Client.create email: email, description: name
      payment = Paymill::Payment.create token: paymill_card_token, client: client.id
      subscription = Paymill::Subscription.create offer: plan.paymill_id, client: client.id, payment: payment.id
      if subscription
        if plan_id < firm.plan.id
          firm.remove_associations_when_downgrading(plan_id)
        end
        set_card_info(subscription)
        Subscription.delete_old_subscription(firm)
      end
      self.paymill_id = subscription.id
      set_card_info(subscription) 
      save!
    end
  rescue Paymill::PaymillError => e
    logger.error "Paymill error while creating customer: #{e.message}"
    errors.add :base, "There was a problem with your credit card. Please try again."
    false
  end
  
  def self.delete_old_subscription(firm) 
    self.where(firm_id: firm.id).destroy_all 
  end
  
  def self.delete_old_paymill_sub(sub_paymill_id)
    Paymill::Subscription.delete(sub_paymill_id)
  end
   
  def update_firm_plan 
    self.firm.update_plan(plan_id)
  end
  
  def self.make_inactive(paymill_id)
    sub = self.where(paymill_id: paymill_id).first
    if sub.active == true
      sub.active = false
      sub.save
    end
  end
  
  def self.make_active(paymill_id)
    sub = self.where(paymill_id: paymill_id).first
    if sub.active == false
      sub.active = true
      sub.save
    end
  end
  
  private
  def set_card_info(subscription)
    payment = subscription.client["payment"][0]
    self.active          = true
    self.card_holder     = payment["card_holder"]
    self.last_four       = payment["last4"]
    self.card_type       = payment["card_type"]
    self.card_expiration = "#{ payment["expire_month"] }-#{ payment["expire_year"] }"
    self.next_bill_on    = Date.parse(Time.at("#{subscription.next_capture_at}".to_i).to_s)
  end
end