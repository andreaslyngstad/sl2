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
      check_transaction?
      subscription = Paymill::Subscription.find(subscription_create.id)

      if subscription
        if plan_id < firm.plan.id
          firm.remove_associations_when_downgrading(plan_id)
        end
        set_properties(subscription) 
        firm.open!
        Subscription.delete_old_subscription(firm, id)
        Subscription.delete_old_paymill_sub(subscription_create.id)
        firm.update_plan(plan_id)
      end

      
      save!
    end
  rescue Paymill::PaymillError => e
    logger.error "Paymill error while creating customer: #{e.message}"
    errors.add :base, "#{e.message}. Please try again or contact support@squadlink.com for help."
    false
  end
  
  def check_transaction?
    case Paymill::Transaction.all({client: client.id, order: "created_at_desc"})[0].response_code
      when 20000 then true
      # when 10001 then errors.add :base, "General undefined response." false
      # when 10002 then errors.add :base, "Still waiting on something." false
      
      # when 40000 then errors.add :base, "General problem with data." false
      # when 40001 then errors.add :base, "General problem with payment data." false
      # when 40100 then errors.add :base, "Problem with credit card data." false
      # when 40101 then errors.add :base, "Problem with cvv." false
      # when 40102 then errors.add :base, "Card expired or not yet valid." false
      # when 40103 then errors.add :base, "Limit exceeded." false
      # when 40104 then errors.add :base, "Card invalid." false
      # when 40105 then errors.add :base, "Expiry date not valid." false
      when 40106 then errors.add :base, "Credit card brand required."; return false
      # when 40200 then errors.add :base, "Problem with bank account data." false
      # when 40201 then errors.add :base, "Bank account data combination mismatch." false
      # when 40202 then errors.add :base, "User authentication failed." false
      # when 40300 then errors.add :base, "Problem with 3d secure data." false
      # when 40301 then errors.add :base, "Currency / amount mismatch" false
      # when 40400 then errors.add :base, "Problem with input data." false
      # when 40401 then errors.add :base, "Amount too low or zero." false
      # when 40402 then errors.add :base, "Usage field too long." false
      # when 40403 then errors.add :base, "Currency not allowed." false
      # when 50000 then errors.add :base, "General problem with backend." false
      # when 50001 then errors.add :base, "Country blacklisted." false
      # when 50002 then errors.add :base, "IP address blacklisted." false
      # when 50003 then errors.add :base, "Anonymous IP proxy used." false
      # when 50100 then errors.add :base, "Technical error with credit card." false
      # when 50101 then errors.add :base, "Error limit exceeded." false
      # when 50102 then errors.add :base, "Card declined by authorization system." false
      # when 50103 then errors.add :base, "Manipulation or stolen card." false
      # when 50104 then errors.add :base, "Card restricted." false
      # when 50105 then errors.add :base, "Invalid card configuration data." false
      # when 50200 then errors.add :base, "Technical error with bank account." false
      # when 50201 then errors.add :base, "Card blacklisted." false
      # when 50300 then errors.add :base, "Technical error with 3D secure." false
      # when 50400 then errors.add :base, "Decline because of risk issues." false
      # when 50401 then errors.add :base, "Checksum was wrong." false
      # when 50402 then errors.add :base, "Bank account number was invalid (formal check)." false
      # when 50403 then errors.add :base, "Technical error with risk check." false
      # when 50404 then errors.add :base, "Unknown error with risk check." false
      # when 50405 then errors.add :base, "Unknown bank code." false
      # when 50406 then errors.add :base, "Open chargeback." false
      # when 50407 then errors.add :base, "Historical chargeback." false
      # when 50408 then errors.add :base, "Institution / public bank account (NCA)." false
      # when 50409 then errors.add :base, "KUNO/Fraud." false
      # when 50410 then errors.add :base, "Personal Account Protection (PAP)." false
      # when 50500 then errors.add :base, "General timeout." false
      # when 50501 then errors.add :base, "Timeout on side of the acquirer." false
      # when 50502 then errors.add :base, "Risk management transaction timeout." false
      # when 50600 then errors.add :base, "Duplicate transaction." return false 
      else errors.add :base, "Something whent wrong."; return false
    end
  end

  def self.delete_old_subscription(firm, id) 
    self.where(firm_id: firm.id).where.not(id:id).destroy_all 
  end
  
  def self.delete_old_paymill_sub(sub_paymill_id)
    Paymill::Subscription.delete(sub_paymill_id)
  end
   
  def update_firm_plan
    Payment.make(self) 
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
    self.paymill_client_id = subscription.client["id"]
    self.card_holder     = payment["card_holder"]
    self.last_four       = payment["last4"]
    self.card_type       = payment["card_type"]
    self.card_expiration = "#{ payment["expire_month"] }-#{ payment["expire_year"] }"
    self.next_bill_on    = (Time.at(subscription.next_capture_at)).to_date
  end
end