ActiveAdmin.register User do
  controller do
    def permitted_params
      params.permit user: [:role,:phone,:name,:hourly_rate,:avatar, :email,:password, :password_confirmation, :remember_me]
    end
    def scoped_collection
      User.includes(:firm)
    end
  end
  menu :priority => 4
  config.batch_actions = true
  index do
    selectable_column                            
    column "Firm" do |user|
      link_to user.firm.name, obeqaslksdssdfnfdfysdfxm_firm_path(user.firm)
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
      f.actions
    end
end
