namespace :secrets do
  desc "copy secrets"
  task :setup do
  	 on roles :app do
  	upload("config/secrets.yml", "#{fetch(:shared_path)}/config/secrets.yml")
  end
  end
  
  task :symlink do
  	 on roles :app do
    run "ln -nfs #{fetch(:shared_path)}/config/secrets.yml #{fetch(:release_path)}/config/secrets.yml"
  end
  end
  # after "deploy:setup", "secrets:setup"
	# after "deploy:finalize_update", "secrets:symlink"
end