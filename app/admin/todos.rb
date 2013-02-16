ActiveAdmin.register Todo do
  menu :priority => 8
   config.batch_actions = true
  index do
    selectable_column
    column "Name", :sortable => :name do |todo|
      link_to todo.name, admin_todo_path(todo)
    end
    column :due
    column :completed
    column :prior
   default_actions 
    
  end
  filter :name
  filter :project
  filter :firm
  filter :user
  filter :customer
end
