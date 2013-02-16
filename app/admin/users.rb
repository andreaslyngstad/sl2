ActiveAdmin.register User do
  menu :priority => 4
  config.batch_actions = true
  index do
    selectable_column                            
    column "Firm" do |user|
      link_to user.firm.name, admin_firm_path(user.firm)
    end                     
    column :name                     
    column :email                     
    column :current_sign_in_at        
    column :last_sign_in_at           
    column :sign_in_count             
    default_actions                   
  end                                 
  
  filter :email 
  filter :name 
  
  form do |f|
      f.inputs "Details" do
        f.input :firm
        f.input :name 
        f.input :email
        f.input :password
        f.input :role
        f.input :hourly_rate
        
      end
      f.buttons
    end
end
