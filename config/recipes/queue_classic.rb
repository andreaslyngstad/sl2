after "deploy:update", "foreman:export"    # Export foreman scripts
after "deploy:restart", "foreman:restart"   # Restart application scripts
after "deploy:stop", "foreman:stop"   # Restart application scripts
after "deploy:start", "foreman:start"

# Foreman tasks
namespace :foreman do
desc 'Export the Procfile to Ubuntu upstart scripts'
task :export, :roles => :app do
	run "cd #{release_path}; #{sudo} $(rbenv which foreman) foreman export upstart /etc/init -a #{application} -u #{user} -l #{release_path}/log/foreman"
end

desc "Start the application services"
task :start, :roles => :app do
  run "#{sudo} start #{application}"
end

desc "Stop the application services"

task :stop, :roles => :app do
  run "#{sudo} stop #{application}"
end

desc "Restart the application services"
task :restart, :roles => :app do
  run "#{sudo} stop #{application}"
  run "#{sudo} start #{application}"
  #run "sudo start #{application} || sudo restart #{application}"
end
end