
# Foreman tasks
namespace :foreman do
desc 'Export the Procfile to Ubuntu upstart scripts'
task :export do
	on roles :app do
	foreman_temp = "/tmp/#{fetch(:application)}-foreman"
	run [
	  "mkdir -p #{foreman_temp}",
	  "cd #{release_path}",
	  "/home/deployer/.rvm/gems/ruby-2.1.2/bin/bundle exec foreman export upstart #{foreman_temp} -a #{fetch(:application)} -u #{user} -l #{shared_path}/log -f Procfile",
	  "#{sudo} mv #{foreman_temp}/#{fetch(:application)}*.conf /etc/init/",
	  "rm -rf #{foreman_temp}"
	].join('&&')
	# set :rvm_bin_path, "/home/deployer/.rvm/bin"
	# run "cd #{release_path} && rvmsudo foreman export upstart /etc/init -a #{fetch(:application)} -u #{user} -l #{release_path}/log/foreman"
	# run "cd #{release_path}/Procfile && rvmsudo foreman export upstart /etc/init -a #{fetch(:application)} -u #{user} -l #{release_path}/log/foreman"
	end
end

desc "Start the application services"
task :start do
	on roles :app do
  	run "#{sudo} start #{fetch(:application)}"
	end
end

desc "Stop the application services"

task :stop do
	on roles :app do
  run "#{sudo} stop #{fetch(:application)}"
end
end

desc "Restart the application services"
task :restart do
	on roles :app do
  run "#{sudo} stop #{fetch(:application)}"
  run "#{sudo} start #{fetch(:application)}"
  #run "sudo start #{fetch(:application)} || sudo restart #{fetch(:application)}"
	end
end
end
# after "deploy:update", "foreman:export"    # Export foreman scripts
after "deploy:restart", "foreman:restart"   # Restart application scripts
# after "deploy:stop", "foreman:stop"   # Restart application scripts
 after "deploy", "foreman:start"
