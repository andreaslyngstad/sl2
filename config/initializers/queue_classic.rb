ENV["DATABASE_URL"] = "postgres://squadlink:" + SECRETS_CONFIG["production"][:postgrespassword].to_s + "@localhost/squadlink_production"
puts SECRETS_CONFIG["production"][:postgrespassword]
require 'queue_classic'
QC::Conn.connection = ActiveRecord::Base.connection.raw_connection
$email_jobs = QC::Queue.new("email_jobs")