ActiveAdmin.register User do
  controller do
    helper_method :set
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
    column "Signed in?", :sortable => :current_sign_in_at do |user| 
      user.current_sign_in_at.try(:strftime, "%d.%m.%Y")
    end
     column "Last sign in", :sortable => :last_sign_in_at do |user|
      user.last_sign_in_at.try(:strftime, "%d.%m.%Y")
    end                
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
