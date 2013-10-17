Warden::Manager.before_logout do |record, warden, opts|
  if record.respond_to?(:logout_stamp!)
    record.logout_stamp!
  end
end