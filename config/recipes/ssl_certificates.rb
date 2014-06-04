namespace :certificate do
  desc "Setup certificate configuration for this application"
  task :setup do
  	 on roles :app do
    upload("/home/andreas/ws/sl2/certificates/#{fetch(:application)}.key", "/tmp/#{fetch(:application)}.key")    
    upload("/home/andreas/ws/sl2/certificates/#{fetch(:application)}-unified.crt", "/tmp/#{fetch(:application)}-unified.crt")
    upload("/home/andreas/ws/sl2/certificates/#{fetch(:application)}.crt", "/tmp/#{fetch(:application)}.crt") 
    run "#{sudo} mv /tmp/#{fetch(:application)}.key /etc/ssl/#{fetch(:application)}.key"
    run "#{sudo} mv /tmp/#{fetch(:application)}-unified.crt /etc/ssl/#{fetch(:application)}-unified.crt"   
    run "#{sudo} mv /tmp/#{fetch(:application)}.crt /etc/ssl/#{fetch(:application)}.crt"   
  end
  end
 
end