
require "rvm/capistrano"

require "bundler/capistrano"
require "whenever/capistrano"

load "config/recipes/ssl_certificates"
load "config/recipes/assets"
load "config/recipes/base"
load "config/recipes/nginx"
load "config/recipes/unicorn"
# load "config/recipes/rvm"
load "config/recipes/postgresql"
# load 'deploy/assets'
load "config/recipes/nodejs"
load "config/recipes/queue_classic"
load "config/recipes/check"
load "config/recipes/monit"
load "config/recipes/copy_secrets"

server "162.243.11.153", :web, :app, :db, primary: true
# set :rvm_ruby_string, '2.0.0-p247'
set :rvm_bin_path, "/home/deployer/.rvm/bin"
set :rvm_path, "$HOME/.rvm"
set :rvm_ruby_string, :local
set :host, "162.243.11.153"
set :user, "deployer"
set :application, "squadlink"
set :deploy_to, "/home/#{user}/apps/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false
set :rvm_type, :user
set :scm, "git"
set :repository, "git@github.com:andreaslyngstad/sl2.git"
set :branch, "master"
set :maintenance_template_path, File.expand_path("../recipes/templates/maintenance.html.erb", __FILE__)
set :bundle_without,  [:development, :test]

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

set :whenever_command, "bundle exec whenever"

after "deploy:finalize_update", "deploy:assets:precompile"
before 'deploy:setup', 'certificate:setup'
before 'deploy:install', 'rvm:install_rvm'
before 'deploy:install', 'rvm:install_ruby'
after "deploy", "deploy:cleanup" # keep only the last 5 releases

# To setup new Ubuntu 12.04 server:
# ssh root@162.243.11.153
# adduser deployer
# echo "deployer ALL=(ALL:ALL) ALL" >> /etc/sudoers

# exit
# ssh-copy-id deployer@162.243.11.153
# cap deploy:install
# cap deploy:setup
# cap deploy:cold