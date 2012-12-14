class CreateEmployees < ActiveRecord::Migration
  def self.up
    create_table :employees do |t|
      t.string :name
      t.string :phone
      t.string :email
      t.integer :customer_id, :null => false

      t.timestamps
    end
     add_index :employees, :customer_id
  end

  def self.down
    drop_table :employees
  end
end
