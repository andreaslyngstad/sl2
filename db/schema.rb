# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20101029201150) do

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
    t.text     "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "blogs", :force => true do |t|
    t.text     "title"
    t.text     "content"
    t.text     "author"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "customers", :force => true do |t|
    t.text     "name"
    t.text     "phone"
    t.text     "email"
    t.text     "address"
    t.integer  "firm_id",    :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "customers", ["firm_id"], :name => "index_customers_on_firm_id"

  create_table "employees", :force => true do |t|
    t.text     "name"
    t.text     "phone"
    t.text     "email"
    t.integer  "customer_id", :null => false
    t.integer  "firm_id",     :null => false
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "employees", ["customer_id"], :name => "index_employees_on_customer_id"
  add_index "employees", ["firm_id"], :name => "index_employees_on_firm_id"

  create_table "firms", :force => true do |t|
    t.text     "name"
    t.text     "subdomain"
    t.text     "address"
    t.text     "phone"
    t.text     "currency"
    t.text     "language"
    t.text     "time_zone"
    t.boolean  "closed"
    t.integer  "time_format"
    t.integer  "date_format"
    t.integer  "clock_format"
    t.integer  "plan_id"
    t.integer  "customers_count",   :default => 0
    t.integer  "users_count",       :default => 0
    t.integer  "projects_count",    :default => 0
    t.integer  "logs_count",        :default => 0
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.string   "background"
    t.string   "color"
  end

  add_index "firms", ["plan_id"], :name => "index_firms_on_plan_id"
  add_index "firms", ["subdomain"], :name => "index_firms_on_subdomain"

  create_table "guides", :force => true do |t|
    t.text     "title"
    t.text     "content"
    t.integer  "guides_category_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "guides_categories", :force => true do |t|
    t.string   "title"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "logs", :force => true do |t|
    t.text     "event"
    t.integer  "customer_id"
    t.integer  "user_id",     :null => false
    t.integer  "firm_id",     :null => false
    t.integer  "project_id"
    t.integer  "employee_id"
    t.integer  "todo_id"
    t.boolean  "tracking"
    t.datetime "begin_time"
    t.datetime "end_time"
    t.date     "log_date"
    t.float    "hours"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "logs", ["customer_id"], :name => "index_logs_on_customer_id"
  add_index "logs", ["employee_id"], :name => "index_logs_on_employee_id"
  add_index "logs", ["firm_id"], :name => "index_logs_on_firm_id"
  add_index "logs", ["project_id"], :name => "index_logs_on_project_id"
  add_index "logs", ["todo_id"], :name => "index_logs_on_todo_id"
  add_index "logs", ["user_id"], :name => "index_logs_on_user_id"

  create_table "memberships", :force => true do |t|
    t.integer  "project_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "memberships", ["project_id", "user_id"], :name => "index_memberships_on_project_id_and_user_id", :unique => true

  create_table "milestones", :force => true do |t|
    t.text     "goal"
    t.date     "due"
    t.integer  "firm_id",    :null => false
    t.boolean  "completed"
    t.integer  "project_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "milestones", ["firm_id"], :name => "index_milestones_on_firm_id"
  add_index "milestones", ["project_id"], :name => "index_milestones_on_project_id"

  create_table "plans", :force => true do |t|
    t.text     "paymill_id"
    t.text     "name"
    t.float    "price"
    t.integer  "customers"
    t.integer  "logs"
    t.integer  "projects"
    t.integer  "users"
    t.integer  "firms_count",         :default => 0
    t.integer  "subscriptions_count", :default => 0
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  create_table "projects", :force => true do |t|
    t.text     "name"
    t.text     "description"
    t.date     "due"
    t.boolean  "active"
    t.float    "budget"
    t.float    "hour_price"
    t.integer  "firm_id",     :null => false
    t.integer  "customer_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "projects", ["customer_id"], :name => "index_projects_on_customer_id"
  add_index "projects", ["firm_id"], :name => "index_projects_on_firm_id"

  create_table "statistics", :force => true do |t|
    t.integer  "firms"
    t.integer  "users"
    t.integer  "free"
    t.integer  "bronze"
    t.integer  "silver"
    t.integer  "gold"
    t.integer  "platinum"
    t.integer  "logs"
    t.integer  "customers"
    t.integer  "projects"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "subscriptions", :force => true do |t|
    t.integer  "plan_id"
    t.text     "email"
    t.text     "name"
    t.integer  "firm_id"
    t.text     "paymill_id"
    t.text     "card_zip"
    t.text     "last_four"
    t.text     "card_type"
    t.date     "next_bill_on"
    t.text     "card_expiration"
    t.text     "card_holder"
    t.boolean  "active"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "subscriptions", ["plan_id", "firm_id"], :name => "index_subscriptions_on_plan_id_and_firm_id"

  create_table "todos", :force => true do |t|
    t.text     "name"
    t.integer  "user_id"
    t.integer  "firm_id",         :null => false
    t.integer  "project_id"
    t.integer  "customer_id"
    t.integer  "done_by_user_id"
    t.integer  "prior"
    t.date     "due"
    t.boolean  "completed"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "todos", ["customer_id"], :name => "index_todos_on_customer_id"
  add_index "todos", ["done_by_user_id"], :name => "index_todos_on_done_by_user_id"
  add_index "todos", ["firm_id"], :name => "index_todos_on_firm_id"
  add_index "todos", ["project_id"], :name => "index_todos_on_project_id"
  add_index "todos", ["user_id"], :name => "index_todos_on_user_id"

  create_table "users", :force => true do |t|
    t.text     "role"
    t.text     "phone"
    t.text     "name"
    t.integer  "firm_id",                                              :null => false
    t.float    "hourly_rate"
    t.string   "loginable_type",         :limit => 40
    t.integer  "loginable_id"
    t.text     "loginable_token"
    t.datetime "created_at",                                           :null => false
    t.datetime "updated_at",                                           :null => false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.text     "email",                                :default => "", :null => false
    t.string   "encrypted_password",                   :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                        :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["firm_id"], :name => "index_users_on_firm_id"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
