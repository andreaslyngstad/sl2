
ENV["DATABASE_URL"] = "postgres://squadlink:" + SECRETS_CONFIG["production"][:postgrespassword].to_s + "@localhost/squadlink_production"

$email_jobs = QC::Queue.new("email_jobs")