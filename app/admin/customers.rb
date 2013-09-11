ActiveAdmin.register Customer do
  controller do
     def scoped_collection
       Customer.includes(:firm)
     end
   end
  menu :priority => 5
  config.batch_actions = true
  index do
    selectable_column                            
    column "Firm", :sortable => :firm_id do |customer|
      link_to customer.firm.name, admin_customer_path(customer.firm)
    end                     
    column :name                     
    column :email                     
            
    default_actions                   
  end                                 
  
  filter :email 
  filter :name 
end
