ActiveAdmin.register Log do
  menu :priority => 6
  config.batch_actions = true
  index do
    selectable_column
    column :event 
    column "Firm", :sortable => :firm_id do |log|
      link_to log.firm.name, admin_firm_path(log.firm)
    end
    column "Project", :sortable => :project_id do |log|
      if log.project
        link_to log.project.name, admin_project_path(log.project)
      end
    end
    column "User", :sortable => :user_id do |log|
      link_to log.user.name, admin_user_path(log.user)
    end
    column "Customer", :sortable => :customer_id do |log|
      if log.customer
        link_to log.customer.name, admin_customer_path(log.customer)
      end
    end
    default_actions 
  end
  filter :event
  filter :project
  filter :firm
  filter :user
  filter :customer
  form do |f|
      f.inputs "Details" do
        f.input :firm
        f.input :user
        f.input :customer
        f.input :project
        f.input :todo
        f.input :event 
        f.input :log_date
        f.input :hours
      end
      f.buttons
    end
  
end
