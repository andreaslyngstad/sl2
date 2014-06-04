namespace :nodejs do
  desc "Install Node.js"
  task :install do
  	on roles :app do
    run "#{sudo} apt-get -y install nodejs"
  end
  end
  # after "deploy:install", "nodejs:install"
end
