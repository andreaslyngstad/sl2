namespace :certificate do
  desc "Setup certificate configuration for this application"
  task :setup, roles: :web do
    upload("/home/andreas/ws/sl2/certificates/#{application}.key", "/tmp/#{application}.key")    
    upload("/home/andreas/ws/sl2/certificates/#{application}-unified.crt", "/tmp/#{application}-unified.crt") 
    run "#{sudo} mv /tmp/#{application}.key /etc/ssl/#{application}.key"
    run "#{sudo} mv /tmp/#{application}-unified.crt /etc/ssl/#{application}-unified.crt"   
  end
 
end