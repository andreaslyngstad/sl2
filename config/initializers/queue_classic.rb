# require 'queue_classic'
# QC::Conn.connection = ActiveRecord::Base.connection.raw_connection
if Rails.env == 'production'
ENV["DATABASE_URL"] = "postgres://squadlink:" + SECRETS_CONFIG["production"][:postgrespassword].to_s + "@localhost/squadlink_production"
end
if Rails.env == 'development'
ENV["DATABASE_URL"] = "postgres://andreas:lekmedmeg@localhost/squadlink_development"
end
if Rails.env == 'test'
ENV["DATABASE_URL"] = "postgres://andreas:lekmedmeg@localhost/squadlink_test"
end