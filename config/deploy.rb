# config valid only for Capistrano 3.1
lock '3.2.1'

# load "config/recipes/ssl_certificates"
# load "config/recipes/assets"
# load "config/recipes/base"
# load "config/recipes/nginx"
# load "config/recipes/unicorn"
# load "config/recipes/rvm"
# # load "config/recipes/postgresql"
# load 'deploy/assets'
# load "config/recipes/nodejs"
# load "config/recipes/queue_classic"
# load "config/recipes/check"
# load "config/recipes/monit"
# load "config/recipes/imagemagick"
# load "config/recipes/copy_secrets"
server "162.243.12.155", roles: [:web, :app, :db]
set :host, "162.243.12.155"
set :user, "deployer"
set :repo_url, 'git@github.com:andreaslyngstad/sl2.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call






# Default value for :pty is false
set :pty, true
set :rvm_type, :user                     # Defaults to: :auto
set :rvm_ruby_version, '2.1.2'
# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }



# set :rvm_ruby_string, '2.1.2'
# set :rvm_bin_path, "/home/deployer/.rvm/bin"
# set :rvm_path, "$HOME/.rvm"
# set :rvm_ruby_string, :local
# set :rvm_autolibs_flag, 4

set :application, "squadlink"
set :deploy_to, "/home/#{fetch(:user)}/apps/#{fetch(:application)}"
# set :deploy_via, :remote_cache
set :use_sudo, false
set :scm, :git
set :repository, "git@github.com:andreaslyngstad/sl2.git"
set :branch, "master"
set :maintenance_template_path, File.expand_path("../recipes/templates/maintenance.html.erb", __FILE__)
set :bundle_without,  [:development, :test]

# default_run_options[:pty] = true
# ssh_options[:forward_agent] = true

set :whenever_command, "bundle exec whenever"

# after "deploy:finalize_update", "deploy:assets:precompile"
# before 'deploy:install', 'rvm:install_rvm'
# before 'deploy:install', 'rvm:install_ruby'
# after "deploy", "deploy:cleanup" # keep only the last 5 releases

# To setup new Ubuntu 12.04 server:
# ssh root@162.243.12.155
# passwd root
# adduser deployer
# echo "deployer ALL=(ALL:ALL) ALL" >> /etc/sudoers

# exit
# ssh-copy-id deployer@162.243.12.155

# install rvm and ruby
# cap deploy:install
# cap deploy:setup
# cap deploy:cold
namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end
