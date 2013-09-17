# set_default :ruby_version, "1.9.3-p125"
# set_default :rbenv_bootstrap, "bootstrap-ubuntu-10-04"

# namespace :rvm do
#   desc "Install rvm, Ruby, and the Bundler gem"
#   task :install, roles: :app do
#     run "\curl -L https://get.rvm.io | bash -s stable --ruby"
#     run "source /home/deployer/.rvm/scripts/rvm"
#     run "gem install bundler --no-ri --no-rdoc"
#   end
#   after "deploy:install", "rbenv:install"
# end
