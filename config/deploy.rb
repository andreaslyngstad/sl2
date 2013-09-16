require "bundler/capistrano"
require "rvm/capistrano"
require "whenever/capistrano"

load "config/recipes/base"
load "config/recipes/nginx"
load "config/recipes/unicorn"
load "config/recipes/postgresql"
load "config/recipes/nodejs"
load "config/recipes/rvm"
load "config/recipes/check"

server "72.14.183.209", :web, :app, :db, primary: true

set :user, "deployer"
set :application, "squadlink"
set :deploy_to, "/home/#{user}/apps/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false

set :scm, "git"
set :repository, "git@github.com:andreaslyngstad/sl2.git"
set :branch, "master"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true
set :whenever_command, "bundle exec whenever"
after "deploy", "deploy:cleanup" # keep only the last 5 releases
