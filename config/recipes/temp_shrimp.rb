namespace :shrimp do
  desc "symlink temp/shrimp"
  
  task :setup do
  	on roles :app do
  	run "mkdir -p #{fetch(:shared_path)}/tmp/shrimp/"
  	run "mkdir -p #{fetch(:release_path)}/tmp/shrimp/"
    run "ln -nfs #{fetch(:shared_path)}/tmp/shrimp/ #{fetch(:release_path)}/tmp/shrimp/"
  end
end
 #  after "deploy:setup", "shrimp:setup"
	# after "deploy:finalize_update", "secrets:symlink"
end