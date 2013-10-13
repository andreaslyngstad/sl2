namespace :secrets do
  desc "copy secrets"
  task :setup, roles: :app do
  	upload("config/secrets.yml", "#{shared_path}/config/secrets.yml")
  end
  
  task :symlink, roles: :app do
    run "ln -nfs #{shared_path}/config/secrets.yml #{release_path}/config/secrets.yml"
  end
  after "deploy:setup", "secrets:setup"
	after "deploy:finalize_update", "secrets:symlink"
end