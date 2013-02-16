require "bundler/capistrano"
require "rvm/capistrano"

set :whenever_command, "bundle exec whenever"
require "whenever/capistrano"

set :rvm_ruby_string, 'ruby-1.9.2-p290'
set :rvm_type, :user  # Don't use system-wide RVM
load 'deploy/assets'

server "50.57.155.135:2805", :web, :app, :db, primary: true

set :application, "squadlink.com"


set :scm, :git
set :repository,  "git@github.com:andreaslyngstad/sl2.git"
set :branch, "master"


set :user, "andreas"

set :deploy_to, "/home/#{user}/apps/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

namespace :deploy do
  desc "Restarting mod_rails with restart.txt"
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
  
  task :setup_config, roles: :app do
    
    run "mkdir -p #{shared_path}/config"
    put File.read("config/database.example.yml"), "#{shared_path}/config/database.yml"
    puts "Now edit the config files in #{shared_path}."
  end
  
   after "deploy:setup", "deploy:setup_config"
    
  
   
   desc "Symlink shared configs and folders on each release."
   task :symlink_config, roles: :app do
   run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
  after "deploy:finalize_update", "deploy:symlink_config"

  desc "Make sure local git is in sync with remote."
  task :check_revision, roles: :web do
    unless `git rev-parse HEAD` == `git rev-parse origin/master`
      puts "WARNING: HEAD is not the same as origin/master"
      puts "Run `git push` to sync changes."
      exit
    end
  end
  before "deploy", "deploy:check_revision"
after "deploy", "deploy:cleanup"

end