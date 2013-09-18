require "bundler/capistrano"
require "rvm/capistrano"
require "whenever/capistrano"

load "config/recipes/base"
load "config/recipes/nginx"
load "config/recipes/unicorn"
load "config/recipes/rbenv"
load "config/recipes/postgresql"
load "config/recipes/nodejs"
load "config/recipes/queue_classic"
load "config/recipes/check"
load "config/recipes/monit"
load "config/recipes/copy_secrets"

server "162.243.11.153", :web, :app, :queue, :db, primary: true

set :user, "deployer"
set :application, "squadlink"
set :deploy_to, "/home/#{user}/apps/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false

set :scm, "git"
set :repository, "git@github.com:andreaslyngstad/sl2.git"
set :branch, "master"
set :maintenance_template_path, File.expand_path("../recipes/templates/maintenance.html.erb", __FILE__)

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

set :whenever_command, "bundle exec whenever"

after "deploy", "deploy:cleanup" # keep only the last 5 releases

# To setup new Ubuntu 12.04 server:
# ssh root@69.164.192.207
# adduser deployer
# echo "deployer ALL=(ALL:ALL) ALL" >> /etc/sudoers
# exit
# ssh-copy-id deployer@69.164.192.207
# cap deploy:install
# cap deploy:setup
# cap deploy:cold