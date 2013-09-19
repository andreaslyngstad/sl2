# namespace :deploy do
#   # http://stackoverflow.com/questions/9016002/speed-up-assetsprecompile-with-rails-3-1-3-2-capistrano-deployment
#   namespace :assets do
#     task :precompile, :roles => :web, :except => { :no_release => true } do
#       from = source.next_revision(current_revision) rescue nil
      
#       if from.nil? || capture("cd #{latest_release} && #{source.local.log(from)} vendor/assets/ app/assets/ | wc -l").to_i > 0
#         run %Q{cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:precompile}
#       else
#         logger.info "Skipping asset pre-compilation because there were no asset changes"
#       end
#     end
#   end
# end

namespace :deploy do
  namespace :assets do
    desc 'Run the precompile task locally and rsync with shared'
    task :precompile, :roles => :web do
      # if releases.length <= 1 || capture("cd #{latest_release} && #{source.local.log(from)} vendor/assets/ app/assets/ | wc -l").to_i > 0
         # %x{bundle exec rake assets:precompile}
         # %x{rsync --recursive --times --rsh=ssh --compress --human-readable --progress public/assets #{user}@#{host}:#{shared_path}}
         # %x{bundle exec rake assets:clean}

  run_locally "bundle exec rake assets:precompile"
  run_locally "cd public; tar -zcvf assets.tar.gz assets"
  top.upload "public/assets.tar.gz", "#{shared_path}", :via => :scp
  run "cd #{shared_path}; tar -zxvf assets.tar.gz"
  run "ln -nfs #{shared_path}/assets #{release_path}/public/assets"
  
  run_locally "rm public/assets.tar.gz"    
      # else
         # logger.info "Skipping asset pre-compilation because there were no asset changes"
      # end
    end
  end
end
