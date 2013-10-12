namespace :monit do
  desc "Install Monit"
  task :install do
    run "#{sudo} apt-get -y install monit"
  end
  after "deploy:install", "monit:install"

  desc "Setup all Monit configuration"
  task :setup do
    
    # run "#{sudo} openssl req -new -x509 -days 365 -nodes -out /etc/monit/monit.pem -keyout /etc/monit/monit.pem"  do |ch, stream, out|
    #   ch.send_data "NO"+"\n" if out =~ /Country Name/
    #   ch.send_data "ostfold"+"\n" if out =~ /State or Province Name/
    #   ch.send_data "spydeberg"+"\n" if out =~ /Locality Name/
    #   ch.send_data "\n" if out =~ /Organization Name/
    #   ch.send_data "\n" if out =~ /Organizational Unit Name/
    #   ch.send_data "\n" if out =~ /Common Name/
    #   ch.send_data "\n" if out =~ /Email Address/
    # end
    # run "#{sudo} openssl gendh 512 >> /etc/monit/monit.pem"
    # run "#{sudo} openssl x509 -subject -dates -fingerprint -noout -in /etc/monit/monit.pem"
    # run "#{sudo} chmod 700 /etc/monit/monit.pem"
    monit_config "monitrc", "/etc/monit/monitrc"
    nginx
    postgresql
    unicorn
    syntax
    reload
  end
  after "deploy:setup", "monit:setup"
  
  task(:nginx, roles: :web) { monit_config "nginx" }
  task(:postgresql, roles: :db) { monit_config "postgresql" }
  task(:unicorn, roles: :app) { monit_config "unicorn" }

  %w[start stop restart syntax reload].each do |command|
    desc "Run Monit #{command} script"
    task command do
      run "#{sudo} service monit #{command}"
    end
  end
end

def monit_config(name, destination = nil)
  destination ||= "/etc/monit/conf.d/#{name}.conf"
  template "monit/#{name}.erb", "/tmp/monit_#{name}"
  run "#{sudo} mv /tmp/monit_#{name} #{destination}"
  run "#{sudo} chown root #{destination}"
  run "#{sudo} chmod 600 #{destination}"
end
