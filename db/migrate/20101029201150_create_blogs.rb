class CreateBlogs < ActiveRecord::Migration
  def change
    create_table :blogs do |t|
      t.text :author
      t.text :title
      t.text :content

      t.timestamps
    end
  end
end
