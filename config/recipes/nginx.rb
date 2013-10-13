namespace :nginx do
  desc "Install nginx"
  task :install, roles: :web do
    run "#{sudo} apt-get -y install nginx"
  end
  after "deploy:install", "nginx:install", "certificate:setup"

  desc "Setup nginx configuration for this application"
  task :setup, roles: :web do
    template "nginx_unicorn.erb", "/tmp/nginx_conf"    
    run "#{sudo} mv /tmp/nginx_conf /etc/nginx/sites-enabled/#{application}"
    run "#{sudo} rm -f /etc/nginx/sites-enabled/default"
    # template "nginxConf.erb", "/tmp/nginxConf"
    # run "#{sudo} rm -f /etc/nginx/nginx.conf"
    # run "#{sudo} mv /tmp/nginxConf /etc/nginx/nginx.conf"
    restart
  end
  after "deploy:setup", "nginx:setup"

  %w[start stop restart].each do |command|
    desc "#{command} nginx"
    task command, roles: :web do
      run "#{sudo} service nginx #{command}"
    end
  end
end
