Rails.configuration.customerio = {
  :site_id      => SECRETS_CONFIG[Rails.env][:customer_io_SITE_ID],
  :api_key      => SECRETS_CONFIG[Rails.env][:aef1feca7f004425362e]
}
  
$customerio = Customerio::Client.new(Rails.configuration.customerio[:site_id], Rails.configuration.customerio[:api_key])