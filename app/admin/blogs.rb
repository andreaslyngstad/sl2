ActiveAdmin.register Blog do
  index do
    selectable_column
    column :title 
    column :author
    column :created_at
    column :updated_at
    default_actions 
  end
  form do |f|
    f.inputs "Details" do
	      f.input :author,:as => :string
	      f.input :title,:as => :string
	      f.input :content 
	    end
      f.actions
    end
end