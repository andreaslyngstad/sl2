class Subscription < ActiveRecord::Base
  # attr_accessible :name, :email, :paymill_id, :paymill_card_token, :plan_id,:firm_id, :plan, :firm, :next_bill_on, :card_holder
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
      subscription_create = Paymill::Subscription.create offer: plan.paymill_id, client: client.id, payment: payment.id
      subscription = Paymill::Subscription.find(subscription_create.id)
      
      if subscription
        if plan_id < firm.plan.id
          firm.remove_associations_when_downgrading(plan_id)
        end
        set_properties(subscription) 
        firm.open!
        Subscription.delete_old_subscription(firm)
      end
      set_properties(subscription)
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
  def self.set_not_paid_not_active
    not_paid = where("next_bill_on < ?", DateTime.now)
    not_paid.each do |s| 
      s.active = false
      s.save
    end
  end
  
  def self.send_email_to_expired_subscriptions
    overdue = where("next_bill_on = ?", DateTime.now - 1.day)
    overdue.each do |s|
      s.close_the_firm_down
      FirmMailer.overdue(s).deliver
    end
  end
  def self.send_email_two_weeks_overdue
    overdue = where("next_bill_on = ?", DateTime.now - 14.day)
    overdue.each do |s|
      s.close_the_firm_down
      FirmMailer.two_weeks_overdue(s).deliver
    end
  end
  def self.one_month_overdue
    overdue = where("next_bill_on = ?", DateTime.now - 1.month)
    overdue.each do |s|
      s.close_the_firm_down
      FirmMailer.reverting_to_free(s).deliver
      # s.firm.revert_to_free_no_payment
    end
  end
  def close_the_firm_down
    self.firm.close! 
  end
  private
  def set_properties(subscription)
    payment = subscription.client["payment"][0]
    self.active          = true
    self.paymill_id      = subscription.id 
    self.card_holder     = payment["card_holder"]
    self.last_four       = payment["last4"]
    self.card_type       = payment["card_type"]
    self.card_expiration = "#{ payment["expire_month"] }-#{ payment["expire_year"] }"
    self.next_bill_on    = (Time.at(subscription.next_capture_at)).to_date
  end
end