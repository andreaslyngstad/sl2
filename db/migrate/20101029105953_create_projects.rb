class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.text :name
      t.text :description
      t.boolean :active
      t.float :budget
      t.float :hour_price
      t.integer :firm_id, :null => false
      t.integer :customer_id
      t.integer :invoices_count, :default => 0
      t.timestamps
    end
    add_index :projects, :firm_id
    add_index :projects, :customer_id
  end

  def self.down
    drop_table :projects
  end
end
