class CreateGuidesCategories < ActiveRecord::Migration
  def change
    create_table :guides_categories do |t|
      t.string :title
      t.timestamps
    end
  end
end
 