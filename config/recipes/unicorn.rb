set :unicorn_user, fetch(:user)
set :unicorn_pid, "#{fetch(:current_path)}/tmp/pids/unicorn.pid" 
set :unicorn_config, "#{fetch(:shared_path)}/config/unicorn.rb" 
set :unicorn_log, "#{fetch(:shared_path)}/log/unicorn.log" 
set :unicorn_workers, 1

namespace :unicorn do
  desc "Setup Unicorn initializer and app configuration"
  task :setup do
  on roles :app do
    run "mkdir -p #{shared_path}/config"
    template "unicorn.rb.erb", unicorn_config
    template "unicorn_init.erb", "/tmp/unicorn_init"
    run "chmod +x /tmp/unicorn_init"
    run "#{sudo} mv /tmp/unicorn_init /etc/init.d/unicorn_#{fetch(:application)}"
    run "#{sudo} update-rc.d -f unicorn_#{fetch(:application)} defaults"
  end
  end
  # after "deploy:setup", "unicorn:setup"

  %w[start stop restart].each do |command|
    desc "#{command} unicorn"
    task command do
      on roles :app do

      run "service unicorn_#{fetch(:application)} #{command}"
    end
    end
    after "unicorn:#{command}", "unicorn:#{command}"
  end
end
