require "queue_classic"
require "queue_classic/tasks"

log_file = File.join(Rails.root, 'log', 'qc.log')
logger = Logger.new(log_file)
pid = `ps -ef | grep -v grep | grep 'rake qc:work' | awk '{print $2}'`
pid.strip!
pid_file = File.join('/home/deploy/apps/squadlink_production/shared','tmp', 'pids', 'qc.pid')
File.delete(pid_file) if File.exists?(pid_file)
`echo '#{pid}' > #{pid_file}`
logger.info "[#{Time.now.to_s(:db)}] [Info] Started with pid - #{pid}"