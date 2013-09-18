namespace :rvm do
  desc "Install rvm, Ruby, and the Bundler gem"
  task :install, roles: :app do
  	run "#{sudo} apt-get -y install curl git-core"
    run "\curl -L https://get.rvm.io | bash -s stable --ruby"
    run "source /home/deployer/.rvm/scripts/rvm"
    run "gem install bundler --no-ri --no-rdoc"
  end
  after "deploy:install", "rbenv:install"
end
