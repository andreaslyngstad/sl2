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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20101029201158) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: true do |t|
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "admin_users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "blogs", force: true do |t|
    t.text     "author"
    t.text     "title"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "customers", force: true do |t|
    t.text     "name"
    t.text     "phone"
    t.text     "email"
    t.text     "address"
    t.text     "zip"
    t.text     "city"
    t.text     "country"
    t.datetime "deleted_at"
    t.integer  "invoices_count", default: 0
    t.integer  "firm_id",                    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "customers", ["firm_id"], name: "index_customers_on_firm_id", using: :btree

  create_table "emails", force: true do |t|
    t.string   "address"
    t.text     "subject"
    t.text     "content"
    t.integer  "invoice_id"
    t.integer  "firm_id"
    t.date     "sent"
    t.text     "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "employees", force: true do |t|
    t.text     "name"
    t.text     "phone"
    t.text     "email"
    t.integer  "customer_id", null: false
    t.integer  "firm_id",     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "employees", ["customer_id"], name: "index_employees_on_customer_id", using: :btree
  add_index "employees", ["firm_id"], name: "index_employees_on_firm_id", using: :btree

  create_table "firms", force: true do |t|
    t.text     "name"
    t.text     "subdomain"
    t.text     "address"
    t.text     "phone"
    t.text     "currency"
    t.text     "language",                default: "en"
    t.text     "time_zone"
    t.float    "tax"
    t.float    "reminder_fee"
    t.integer  "days_to_due",             default: 14
    t.text     "invoice_email"
    t.text     "invoice_email_subject"
    t.text     "invoice_email_message"
    t.text     "on_invoice_message"
    t.text     "reminder_email_subject"
    t.text     "reminder_email_message"
    t.text     "on_reminder_message"
    t.text     "bank_account"
    t.text     "vat_number"
    t.datetime "last_sign_in_at"
    t.boolean  "closed"
    t.integer  "time_format"
    t.integer  "date_format"
    t.integer  "clock_format"
    t.integer  "plan_id"
    t.integer  "starting_invoice_number", default: 1
    t.integer  "customers_count",         default: 0
    t.integer  "users_count",             default: 0
    t.integer  "projects_count",          default: 0
    t.integer  "logs_count",              default: 0
    t.integer  "invoices_count",          default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.string   "background"
    t.string   "color"
  end

  add_index "firms", ["plan_id"], name: "index_firms_on_plan_id", using: :btree
  add_index "firms", ["subdomain"], name: "index_firms_on_subdomain", using: :btree

  create_table "guides", force: true do |t|
    t.text     "title"
    t.text     "content"
    t.integer  "guides_category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "guides_categories", force: true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invoice_lines", force: true do |t|
    t.float    "quantity"
    t.text     "description"
    t.float    "price"
    t.float    "amount"
    t.float    "tax"
    t.integer  "invoice_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invoices", force: true do |t|
    t.integer  "number"
    t.text     "content"
    t.integer  "project_id"
    t.integer  "customer_id",        null: false
    t.integer  "invoice_id"
    t.integer  "reminder_on_id"
    t.integer  "firm_id",            null: false
    t.integer  "status"
    t.datetime "reminder_sent"
    t.float    "reminder_fee"
    t.datetime "sent"
    t.datetime "paid"
    t.datetime "due"
    t.datetime "last_due"
    t.float    "total"
    t.float    "receivable"
    t.float    "invoice_receivable"
    t.datetime "date"
    t.float    "lost"
    t.text     "currency"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "invoices", ["customer_id"], name: "index_invoices_on_customer_id", using: :btree
  add_index "invoices", ["firm_id"], name: "index_invoices_on_firm_id", using: :btree
  add_index "invoices", ["invoice_id"], name: "index_invoices_on_invoice_id", using: :btree
  add_index "invoices", ["project_id"], name: "index_invoices_on_project_id", using: :btree
  add_index "invoices", ["reminder_on_id"], name: "index_invoices_on_reminder_on_id", using: :btree

  create_table "logs", force: true do |t|
    t.text     "event"
    t.integer  "customer_id"
    t.integer  "user_id",                      null: false
    t.integer  "firm_id",                      null: false
    t.integer  "project_id"
    t.integer  "employee_id"
    t.integer  "invoice_id",     default: 0
    t.integer  "credit_note_id", default: 0
    t.integer  "todo_id"
    t.boolean  "tracking"
    t.datetime "begin_time"
    t.datetime "end_time"
    t.date     "log_date"
    t.float    "hours",          default: 0.0
    t.float    "rate",           default: 0.0
    t.float    "tax"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "logs", ["customer_id"], name: "index_logs_on_customer_id", using: :btree
  add_index "logs", ["employee_id"], name: "index_logs_on_employee_id", using: :btree
  add_index "logs", ["firm_id"], name: "index_logs_on_firm_id", using: :btree
  add_index "logs", ["invoice_id"], name: "index_logs_on_invoice_id", using: :btree
  add_index "logs", ["project_id"], name: "index_logs_on_project_id", using: :btree
  add_index "logs", ["todo_id"], name: "index_logs_on_todo_id", using: :btree
  add_index "logs", ["user_id"], name: "index_logs_on_user_id", using: :btree

  create_table "memberships", force: true do |t|
    t.integer  "project_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "memberships", ["project_id", "user_id"], name: "index_memberships_on_project_id_and_user_id", unique: true, using: :btree

  create_table "milestones", force: true do |t|
    t.text     "goal"
    t.date     "due"
    t.integer  "firm_id",    null: false
    t.boolean  "completed"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "milestones", ["firm_id"], name: "index_milestones_on_firm_id", using: :btree
  add_index "milestones", ["project_id"], name: "index_milestones_on_project_id", using: :btree

  create_table "payments", force: true do |t|
    t.integer  "firm_id"
    t.float    "amount"
    t.text     "plan_name"
    t.text     "card_type"
    t.text     "last_four"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "plans", force: true do |t|
    t.text     "paymill_id"
    t.text     "name"
    t.float    "price"
    t.integer  "customers"
    t.integer  "logs"
    t.integer  "projects"
    t.integer  "users"
    t.integer  "invoices"
    t.integer  "firms_count",         default: 0
    t.integer  "subscriptions_count", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "currency"
  end

  create_table "projects", force: true do |t|
    t.text     "name"
    t.text     "description"
    t.boolean  "active"
    t.float    "budget"
    t.float    "hour_price"
    t.integer  "firm_id",                    null: false
    t.integer  "customer_id"
    t.integer  "invoices_count", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "projects", ["customer_id"], name: "index_projects_on_customer_id", using: :btree
  add_index "projects", ["firm_id"], name: "index_projects_on_firm_id", using: :btree

  create_table "queue_classic_jobs", force: true do |t|
    t.text     "q_name",                       null: false
    t.text     "method",                       null: false
    t.text     "args",                         null: false
    t.datetime "locked_at"
    t.integer  "locked_by"
    t.datetime "created_at", default: "now()"
  end

  add_index "queue_classic_jobs", ["q_name", "id"], name: "idx_qc_on_name_only_unlocked", where: "(locked_at IS NULL)", using: :btree

  create_table "statistics", force: true do |t|
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
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subscriptions", force: true do |t|
    t.integer  "plan_id"
    t.text     "email"
    t.text     "name"
    t.integer  "firm_id"
    t.text     "paymill_id"
    t.text     "paymill_client_id"
    t.text     "card_zip"
    t.text     "last_four"
    t.text     "card_type"
    t.date     "next_bill_on"
    t.text     "card_expiration"
    t.text     "card_holder"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "subscriptions", ["plan_id", "firm_id"], name: "index_subscriptions_on_plan_id_and_firm_id", using: :btree

  create_table "todos", force: true do |t|
    t.text     "name"
    t.integer  "user_id"
    t.integer  "firm_id",         null: false
    t.integer  "project_id"
    t.integer  "customer_id"
    t.integer  "done_by_user_id"
    t.integer  "prior"
    t.date     "due"
    t.boolean  "completed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "todos", ["customer_id"], name: "index_todos_on_customer_id", using: :btree
  add_index "todos", ["done_by_user_id"], name: "index_todos_on_done_by_user_id", using: :btree
  add_index "todos", ["firm_id"], name: "index_todos_on_firm_id", using: :btree
  add_index "todos", ["project_id"], name: "index_todos_on_project_id", using: :btree
  add_index "todos", ["user_id"], name: "index_todos_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.text     "role"
    t.text     "phone"
    t.text     "name"
    t.integer  "firm_id",                                         null: false
    t.float    "hourly_rate",                       default: 0.0
    t.string   "loginable_type",         limit: 40
    t.integer  "loginable_id"
    t.text     "loginable_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.text     "email",                             default: "",  null: false
    t.string   "encrypted_password",                default: "",  null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                     default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["firm_id"], name: "index_users_on_firm_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
