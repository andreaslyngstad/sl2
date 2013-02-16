ActiveAdmin.register Project do
  menu :priority => 7
  config.batch_actions = true
  index do
    selectable_column
    column "Name", :sortable => :name do |todo|
      link_to todo.name, admin_todo_path(todo)
    end
    column :due
    column :active
    column :budget
    column :hour_price
    column :created_at
    default_actions
  end
  filter :name
  filter :firm
  filter :project
  filter :customer
  filter :due
  filter :budget
  filter :hour_price
  filter :created_at
end
