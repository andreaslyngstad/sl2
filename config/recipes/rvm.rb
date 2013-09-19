set_default :ruby_version, "2.0.0-p247"
namespace :rvm do
  desc "Install rvm, Ruby, and the Bundler gem"
  task :install, roles: :app do
  	run "#{sudo} apt-get update"
  	run "#{sudo} apt-get install curl"
    run "curl -L https://get.rvm.io | bash"
    put ". ~/.rvm/scripts/rvm"
    run "rvm requirements"
    run "rvm install #{ruby_version}"
    run "rvm use ruby --default"
    run "gem install bundler --no-ri --no-rdoc"
  end
  after "deploy:install", "rvm:install"
end
