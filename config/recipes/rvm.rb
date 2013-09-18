set_default :ruby_version, "2.0.0-p247"
namespace :rvm do
  desc "Install rvm, Ruby, and the Bundler gem"
  task :install, roles: :app do
  	run "#{sudo} apt-get -y install curl git-core"
    run "curl -L https://get.rvm.io | bash"
    run "source /home/deployer/.rvm/scripts/rvm"
    run "rvm install #{ruby_version}"
    run "gem install bundler --no-ri --no-rdoc"
  end
  after "deploy:install", "rvm:install"
end
