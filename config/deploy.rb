set :application, "squadlink.com"
role :app, application
role :web, application
role :db,  application, :primary => true

set :scm, :git
set :repository,  "git@github.com:andreaslyngstad/sl2.git"



set :user, "squadlink"
set :use_sudo, false
set :deploy_to, "/var/www/#{application}"


namespace :deploy do
  desc "Restarting mod_rails with restart.txt"
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end

  desc "Symlink shared configs and folders on each release."
  task :symlink_shared do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end 
end

after 'deploy:update_code', 'deploy:symlink_shared'
after "deploy", "deploy:cleanup"