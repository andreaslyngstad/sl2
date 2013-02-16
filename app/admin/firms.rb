ActiveAdmin.register Firm do
  
  menu :priority => 2
  
  scope :all, :default => true
  scope :free
  scope :bronze
  scope :silver
  scope :gold
  scope :platinum

  config.batch_actions = true
  index do
    selectable_column
    
    column "Name", :sortable => :name do |firm|
      link_to firm.name, admin_firm_path(firm)
    end
    column "Plan", :sortable => :plan_id do |firm|
      firm.subscription.plan.name
    end
    column "Customers", :sortable => :customers_count  do |firm|
      link_to firm.customers_count, customers_admin_firm_path(firm)
    end
    column "Projects", :sortable => :projects_count do |firm|
      link_to firm.projects_count, projects_admin_firm_path(firm)
    end
    column "Users", :sortable => :users_count  do |firm|
      link_to firm.users_count, users_admin_firm_path(firm)
    end
    
    column "Logs", :sortable => :logs_count do |firm|
      link_to firm.logs_count, logs_admin_firm_path(firm)
    end
    column :created_at
    default_actions 
  end
  filter :name 
  filter :subdomain
  filter :created_at
  
  
  
  member_action :customers do
    @firm = Firm.find(params[:id])
  end
  member_action :users do
    @firm = Firm.find(params[:id])
  end
  member_action :projects do
    @firm = Firm.find(params[:id])
  end
  member_action :logs do
    @firm = Firm.find(params[:id])
  end
  form do |f|
    f.inputs "Details" do
      f.input :plan,:as => :select, :collection => Plan.all
      f.input :name
      f.input :subdomain 
      f.input :address
      f.input :phone
      f.input :currency
      f.input :time_zone
      f.input :language
        end
      f.buttons
    end

end
