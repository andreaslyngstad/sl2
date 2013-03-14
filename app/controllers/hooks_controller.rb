class HooksController < ApplicationController
  require 'json'


  def receiver

    data_json = JSON.parse request.body.read

    p data_json['data']['object']['customer']

    if data_json[:type] == "invoice.payment_succeeded"
      Subscription.make_active(data_event)
    end

    if data_json[:type] == "invoice.payment_failed"
      Subscription.make_inactive(data_event)
    end
  end

  
end