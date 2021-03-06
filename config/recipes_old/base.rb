SECRETS_CONFIG = YAML.load(File.read(File.expand_path('../../secrets.yml', __FILE__)))


def template(from, to)
  erb = File.read(File.expand_path("../templates/#{from}", __FILE__))
  put ERB.new(erb).result(binding), to
end

def set_default(name, *args, &block)
  set(name, *args, &block) if defined?(name)
end

namespace :deploy do
  desc "Install everything onto the server"
  task :install do
    run "#{sudo} apt-get -y update"
    run "#{sudo} apt-get -y install python-software-properties"
  end

  desc "Setup up ecverything"
  task :setup do 
  	invoke "monit:setup"
  	invoke "nginx:setup"
  	invoke "shrimp:setup" 
  	invoke "secrets:setup"
  end

end
