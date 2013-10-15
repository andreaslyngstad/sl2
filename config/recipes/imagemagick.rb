namespace :imagemagick do
	desc "Install ImageMagick"
	 after "deploy:install", "nginx:install"
	task :install, :roles => :app do
	 run "#{sudo} apt-get -y install imagemagick" do |ch, stream, out|
	 end
	 #sudo "gem install rmagick"
	end
end