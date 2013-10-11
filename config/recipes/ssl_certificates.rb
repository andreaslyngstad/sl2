namespace :certificate do
  desc "Setup certificate configuration for this application"
  task :setup, roles: :web do
    upload("/home/andreas/ws/sl2/certificates/#{application}.key", "/tmp/#{application}.key")    
    upload("/home/andreas/ws/sl2/certificates/#{application}.crt", "/tmp/#{application}.crt") 
    run "#{sudo} mv /tmp/#{application}.key /etc/ssl/#{application}.key"
    run "#{sudo} mv /tmp/#{application}.crt /etc/ssl/#{application}.crt"   
  end
 
end