class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.string :name
      t.text :description
      t.date :due
      t.boolean :active
      t.float :budget
      t.float :hour_price
      t.integer :firm_id, :null => false
      t.integer :customer_id
      t.timestamps
    end
    add_index :projects, :firm_id
    add_index :projects, :customer_id
  end

  def self.down
    drop_table :projects
  end
end
