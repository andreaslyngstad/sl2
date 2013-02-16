ActiveAdmin.register Plan do
  menu :priority => 3
 config.batch_actions = true
  index do
    selectable_column
    column "Name", :sortable => :name do |plan|
      link_to plan.name, admin_plan_path(plan)
    end
    column "Firms", :sortable => :firms_count  do |plan|
      link_to plan.firms_count, firms_admin_plan_path(plan)
    end
    column :price
    column :customers
    column :projects
    column :users
    default_actions 
  end
  filter :name
  
  member_action :firms do
    @plan = Plan.find(params[:id])
  end
end