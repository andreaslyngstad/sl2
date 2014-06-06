namespace :imagemagick do
	desc "Install ImageMagick"
	  
	task :install do
		on roles :app do
		 run "service unicorn_#{fetch(:application)} #{command}"
	 	run "#{sudo} apt-get -y install imagemagick" do |ch, stream, out|
	 	end
	 end
	 #sudo "gem install rmagick"
	end
	after "deploy:install", "imagemagick:install"
end