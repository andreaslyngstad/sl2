class CreateCustomers < ActiveRecord::Migration
  def self.up
    create_table :customers do |t|
      t.string :name
      t.string :phone
      t.string :email
      t.text :address
      t.integer :firm_id, :null => false
      t.timestamps
    end
    add_index :customers, :firm_id
  end

  def self.down
    drop_table :customers
  end
end
