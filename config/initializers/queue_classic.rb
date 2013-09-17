ENV["DATABASE_URL"] = "postgres://squadlink:" + SECRETS_CONFIG["production"][:postgrespassword].to_s + "@162.243.11.153/squadlink_production"
$email_jobs = QC::Queue.new("email_jobs")