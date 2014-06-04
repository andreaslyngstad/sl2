namespace :nginx do
  desc "Install nginx"
  task :install do
    on roles :web do
    run "#{sudo} apt-get -y install nginx"
   end
  end
  after "deploy:install", "nginx:install"

  desc "Setup nginx configuration for this application"
  task :setup do
    on roles :web do
    template "nginx_unicorn.erb", "/tmp/nginx_conf"    
    run "#{sudo} mv /tmp/nginx_conf /etc/nginx/sites-enabled/#{fetch(:application)}"
    run "#{sudo} rm -f /etc/nginx/sites-enabled/default"
    template "nginxConf.erb", "/tmp/nginxConf"
    run "#{sudo} rm -f /etc/nginx/nginx.conf"
    run "#{sudo} mv /tmp/nginxConf /etc/nginx/nginx.conf"
    run "#{sudo} mkdir -p /usr/share/nginx/logs"
    run "#{sudo} touch /usr/share/nginx/logs/nginx.error.log"
    restart
  end
  end
  # after "deploy:setup", "nginx:setup"

  %w[start stop restart].each do |command|
    desc "#{command} nginx"
    task command do
      on roles :web do
      run "#{sudo} service nginx #{command}"
    end
    end
  end
end
