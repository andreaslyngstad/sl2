ENV["DATABASE_URL"] = "postgres://andreas:lekmedmeg@localhost/squadlink_development"
$email_jobs = QC::Queue.new("email_jobs")