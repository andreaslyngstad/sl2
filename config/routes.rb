require 'subdomain'
Squadlink::Application.routes.draw do

  resources :blogs

  get "/termsofservice" => "public#termsofservice",  :as => :termsofservice
  get "/imprint" => "public#imprint",  :as => :imprint
  get "/privacy_policy" => "public#privacy_policy",  :as => :privacy_policy
  get "/pricing" => "public#pricing",  :as => :pricing
  get "/index" => "public#index",  :as => :index

  resources :guides
  post "hooks/receiver"
    resources :firms
    post "public/create_firm" => "public#create_firm", :as => :create_firm
    resources :public do
      member do
        get "first_user"
        post "create_first_user"
     end
  end  
  ActiveAdmin.routes(self)
  get '/obeqaslksdssdfnfdfysdfxm/dashboard/subscription_chart_data' =>  'obeqaslksdssdfnfdfysdfxm/dashboard#subscription_chart_data'
  get '/obeqaslksdssdfnfdfysdfxm/dashboard/firms_chart_data' =>  'obeqaslksdssdfnfdfysdfxm/dashboard#firms_chart_data'
  get '/obeqaslksdssdfnfdfysdfxm/dashboard/firms_resources_chart_data' =>  'obeqaslksdssdfnfdfysdfxm/dashboard#firms_resources_chart_data'
  get '/obeqaslksdssdfnfdfysdfxm/dashboard/new_firms_count_chart_data' =>  'obeqaslksdssdfnfdfysdfxm/dashboard#new_firms_count_chart_data'
  devise_for :admin_users, ActiveAdmin::Devise.config

  devise_for  :users,
              :path_names => { :sign_up => "register" },
              :controllers => {
              :sessions => "sessions",
              :passwords => "passwords",
              :registrations => "users"
             }

  devise_scope :user do
  	get "/sign_in", :to => "sessions#new"
    delete "/sign_out", :to => "sessions#destroy"
    get "register", :to => "public#register"
  	get "contact", :to => "public#contact"
    get "/sign_in_at_subdomain" =>  "sessions#sign_in_at_subdomain", :as => :sign_in_at_subdomain
  	get "/register/:firm_id/user" => "public#first_user",  :as => :register_user
  	post "/register/:firm_id/user" => "public#create_first_user",  :as => :create_first_user
  	get "/validates_uniqe/:subdomain" => "public#validates_uniqe", :as => :validates_uniqe
    get '/users/password/edit' =>  'devise/passwords#edit', :as => :edit_password
  end
  
  


  constraints(Subdomain) do
    get "plans/index", :as => :plans
    # delete "plans/index", :as => :plans_delete
    get "plans/cancel", :as => :plans_cancel
    resources :subscriptions
    get "payments" => 'payments#index', :as => :payments
    get "payments/:id" => 'payments#show', :as => :payment
    get "payments/download_pdf/:id" => 'payments#download_pdf', :as => :download_pdf
    constraints(PaymentChecker) do
      # devise_for  :users
      resources :users, :only => [:index, :show, :edit, :create, :update, :destroy] do
        member do
         get :valid
        end
      end
      #chart_controller
      get "charts" => "charts#index", :as => :charts
      get "users_logs" => "charts#users_logs",  :as => :users_logs
      get "project_users_logs" => "charts#project_users_logs",  :as => :project_users_logs
      get "project_todos_logs" => "charts#project_todos_logs",  :as => :project_todos_logs
      # get "customer_users_logs" => "charts#customer_users_logs",  :as => :customer_users_logs
      # get "customer_todos_logs" => "charts#customer_todos_logs",  :as => :customer_todos_logs
      get "projects_logs" => "charts#projects_logs",  :as => :projects_logs
      get "customers_logs" => "charts#customers_logs",  :as => :customers_logs
      #projects_controller
      get "/archive" => "projects#archive",  :as => :archive
      put "projects/update_index/:id" => "projects#update_index",  :as => :update_index
      post "projects/create_index/" => "projects#create_index",  :as => :create_index
      post "/activate_projects/:id" => "projects#activate_projects", :as => :activate_projects
      #tabs_controller
      get "/tabs/tabs_state/:id/:class" => "tabs#tabs_state"
      get "/tabs/tabs_todos/:id/:class" => "tabs#tabs_todos", :as => :tabs_todos
      get "/tabs/tabs_milestones/:id/:class" => "tabs#tabs_milestones", :as => :tabs_milestones
      get "/tabs/tabs_projects/:id/:class" => "tabs#tabs_projects", :as => :tabs_projects
      get "/tabs/tabs_employees/:id/:class" => "tabs#tabs_employees", :as => :tabs_employees
      get "/tabs/tabs_logs/:id/:class" => "tabs#tabs_logs", :as => :tabs_logs
      get "/tabs/tabs_users/:id/:class" => "tabs#tabs_users", :as => :tabs_users
      get "/tabs/tabs_statistics/:id/:class" => "tabs#tabs_statistics", :as => :tabs_statistics
      get "/tabs/tabs_spendings/:id/:class" => "tabs#tabs_spendings", :as => :tabs_spendings
      #logs_controller
      post "logs/start_tracking" => "logs#start_tracking",  :as => :start_tracking
      patch "logs/stop_tracking/:id" => "logs#stop_tracking",  :as => :stop_tracking
      get "/get_logs_todo/:todo_id" => "logs#get_logs_todo", :as => :get_logs_todo
      #select_controller
      get "/project_select/:project_id/:log_id" => "select#project_select"
      get "/project_select/:project_id/" => "select#project_select"

      get "/customer_select/:customer_id/:log_id" => "select#customer_select"
      get "/customer_select/:customer_id/" => "select#customer_select"
      get "/todo_select/:todo_id/:log_id" => "select#todo_select"
      get "/todo_select/:todo_id/" => "select#todo_select"
      post "/customer_select_tracking/:customer_id/:log_id" => "select#customer_select_tracking"
      post "/customer_select_tracking/:customer_id/" => "select#customer_select_tracking"

      post "/employee_select_tracking/:employee_id/:log_id" => "select#employee_select_tracking"
      post "/employee_select_tracking/:employee_id/" => "select#employee_select_tracking" 

      post "/project_select_tracking/:project_id/:log_id" => "select#project_select_tracking"
      post "/project_select_tracking/:project_id/" => "select#project_select_tracking"
      
      post "/todo_select_tracking/:todo_id/:log_id" => "select#todo_select_tracking"
      post "/todo_select_tracking/:todo_id/" => "select#todo_select_tracking"

      #timesheets_controller
      get "/timesheet_week/:user_id" => 'timesheets#timesheet_week', :as => :timesheet_week
      get "/timesheet_day/:user_id/:date" => 'timesheets#timesheet_day', :as => :timesheet_day
      get "/timesheet_month/:user_id/:date" => "timesheets#timesheet_month", :as => :timesheet_month
      post "/add_hour_to_project/" => 'timesheets#add_hour_to_project', :as => :add_hour_to_projects
      post "/add_log_timesheet" => 'timesheets#add_log_timesheet', :as => :add_log_timesheet
      #reports_controller
      get "/reports" => 'reports#index', :as => :reports
      get "/squadlink_report" => 'reports#squadlink_report', :as => :squadlink_report
      #memberships_controller
      post "/membership/:id/:project_id" => "memberships#index", :as => :membership
      #firms_controller
      put "/firm_update" => "firms#firm_update",  :as => :firm_update
      get "/firm_edit" => "firms#firm_edit",  :as => :firm_edit
      get "/firm_show" => "firms#firm_show",  :as => :firm_show
      #roster
      get "/roster_milestone" => "roster#get_milestones", :as => :roster_milestone
      get "/roster_task" => "roster#get_tasks", :as => :roster_task
      #timerange
      # get "/logs_pr_date/:time/:url" => "timerange#logs_pr_date", :as => :logs_pr_date
      # match "/logs_pr_date" => "timerange#logs_pr_date", :as => :logs_pr_date
      get "/log_range/" => "timerange#log_range", :as => :log_range
      get "/todo_range/" => "timerange#todo_range", :as => :todo_range
      # get "/todos_pr_date/:time/:url/:id" => "timerange#todos_pr_date", :as => :todos_pr_date  
      resources :customers
      resources :employees
      resources :projects
      resources :milestones
      resources :todos
      resources :logs
      get "/", :to  => "logs#index"
    end
    get "/", :to  => "plans#index"
	end
  root :to => "public#index"
end