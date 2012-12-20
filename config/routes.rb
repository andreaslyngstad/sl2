require 'subdomain'
Squadlink::Application.routes.draw do
    resources :firms
    post "public/create_firm" => "public#create_firm", :as => :create_firm
    resources :public do
      member do
        get "first_user"
        
        post "create_first_user"
     end
  end    
  devise_for  :users,
              :path_names => { :sign_up => "register" },
              :controllers => {
              :sessions => "sessions",
              :passwords => "passwords",
              :registrations => "users"
             }

  devise_scope :user do
    	get "/sign_in", :to => "sessions#new"
      get "/sign_out", :to => "sessions#destroy"
    	get "register", :to => "public#register"
      match "/sign_in_at_subdomain" =>  "sessions#sign_in_at_subdomain", :as => :sign_in_at_subdomain
    	get "/register/:firm_id/user" => "public#first_user",  :as => :register_user
    	post "/register/:firm_id/user" => "public#create_first_user",  :as => :create_first_user
    	get "/validates_uniqe/:subdomain" => "public#validates_uniqe", :as => :validates_uniqe

  	end
  resources :users, :only => [:index, :show, :edit, :create, :update, :destroy] do
    member do
     get :valid
    end
  end

  constraints(Subdomain) do
    root :to	=> "private#statistics"
    devise_for  :users
    #chart_controller
    match "users_logs/:form/:to" => "charts#users_logs",  :as => :users_logs
    match "projects_logs/:form/:to" => "charts#projects_logs",  :as => :projects_logs
    match "customers_logs/:form/:to" => "charts#customers_logs",  :as => :customers_logs
    
    
    #projects_controller
    match "/archive" => "projects#archive",  :as => :archive
    match "projects/update_index/:id" => "projects#update_index",  :as => :update_index
    match "projects/create_index/" => "projects#create_index",  :as => :create_index
    match "/activate_projects/:id" => "projects#activate_projects", :as => :activate_projects
    #tabs_controller
    match "/tabs/todos/:id/:class" => "tabs#todos", :as => :tabs_todos
    match "/tabs/milestones/:id/:class" => "tabs#milestones", :as => :tabs_milestones
    match "/tabs/logs/:id/:class" => "tabs#logs", :as => :tabs_logs
    match "/tabs/users/:id/:class" => "tabs#users", :as => :tabs_users
    #logs_controller
    match "logs/start_tracking" => "logs#start_tracking",  :as => :start_tracking
    match "logs/stop_tracking/:id" => "logs#stop_tracking",  :as => :stop_tracking
    match "/get_logs_todo/:todo_id" => "logs#get_logs_todo", :as => :get_logs_todo
    #select_controller
    match "/customer_select/:customer_id/:log_id" => "select#customer_select", :as => :customer_select
    match "/customer_select_tracking/:customer_id/:log_id" => "select#customer_select_tracking", :as => :customer_select_tracking
    match "/employee_select_tracking/:employee_id/:log_id" => "select#employee_select_tracking", :as => :employee_select_tracking  
    match "/project_select/:project_id/:log_id" => "select#project_select", :as => :project_select
    match "/project_select_tracking/:project_id/:log_id" => "select#project_select_tracking", :as => :project_select_tracking
    match "/todo_select_tracking/:todo_id/:log_id" => "select#todo_select_tracking", :as => :todo_select_tracking
    match "/todo_select/:todo_id/:log_id" => "select#todo_select", :as => :todo_select
    #timesheets_controller
    match "/timesheets/:user_id" => 'timesheets#timesheets', :as => :timesheets
    match "/timesheet_logs_day/:user_id/:date" => 'timesheets#timesheet_logs_day', :as => :timesheet_logs_day
    match "/timesheet_month/:user_id/:date" => "timesheets#timesheet_month", :as => :timesheet_month
    match "/add_log_timesheet" => 'timesheets#add_log_timesheet', :as => :add_log_timesheet
   
    #private_controller
    match "/statistics" => "private#statistics", :as => :statistics
    match "/reports" => 'private#reports', :as => :reports
    
    match "/report_for" => 'private#report_for', :as => :reports_for
    match "/account" => "private#account",  :as => :account
    match "/home_user" => "private#home_user",  :as => :home_user
    match "/upgrade" => "private#upgrade",  :as => :upgrade
    
    match "/membership/:id/:project_id" => "private#membership", :as => :membership
    match "/get_logs/:customer_id" => "private#get_logs", :as => :get_logs
    
    match "/get_logs_project/:project_id" => "private#get_logs_project", :as => :get_logs_project
    match "/get_users_project/:project_id" => "private#get_users_project", :as => :get_users_project
    match "/get_logs_user/:user_id" => "private#get_logs_user", :as => :get_logs_user
    match "/get_employees/:customer_id" => "private#get_employees", :as => :get_employees
    match "/add_todo_to_logs" => "private#add_todo_to_logs", :as => :add_todo_to_logs
    
    #firms_controller
    match "/firm_update" => "firms#firm_update",  :as => :firm_update
    match "/firm_edit" => "firms#firm_edit",  :as => :firm_edit
    #roster
    match "/roster_milestone" => "roster#get_milestones", :as => :roster_milestone
    match "/roster_task" => "roster#get_tasks", :as => :roster_task
    #timerange
    match "/logs_pr_date/:time/:url" => "timerange#logs_pr_date", :as => :logs_pr_date
    match "/logs_pr_date/:time/:url/:id" => "timerange#logs_pr_date", :as => :logs_pr_date
    match "/log_range/" => "timerange#log_range", :as => :log_range
    match "/todo_range/" => "timerange#todo_range", :as => :todo_range
    match "/todos_pr_date/:time/:url/:id" => "timerange#todos_pr_date", :as => :todos_pr_date
    resources :customers
    resources :employees
    resources :projects
    resources :milestones
    resources :todos
    resources :logs
	end
  
  root :to => "public#index"
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
