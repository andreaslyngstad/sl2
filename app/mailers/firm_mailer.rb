class FirmMailer < ActionMailer::Base
  default from: "info@squadlink.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.firm_mailer.sign_up_confirmation.subject
  #
  def sign_up_confirmation
    @greeting = "Hi"

    mail to: "to@example.org"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.firm_mailer.overdue.subject
  #
  def overdue(subscription)
    @greeting = "Hi"

    mail to: subscription.email
  end  

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.firm_mailer.2_weeks_overdue.subject
  #
  def two_weeks_overdue(subscription)
    @greeting = "Hi"

    mail to: subscription.email
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.firm_mailer.reverting_to_free.subject
  #
  def reverting_to_free(subscription)
    @greeting = "Hi"

    mail to: subscription.email
  end
end
