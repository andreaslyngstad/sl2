ENV["DATABASE_URL"] = "postgres://squadlink:" + SECRETS_CONFIG[:postgrespassword] + "@162.243.11.153/squadlink_production"
$email_jobs = QC::Queue.new("email_jobs")