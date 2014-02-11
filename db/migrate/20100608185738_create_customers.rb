class CreateCustomers < ActiveRecord::Migration
  def self.up
    create_table :customers do |t|
      t.text :name
      t.text :phone
      t.text :email
      t.text :address
      t.text :zip
      t.text :city
      t.text :country
      t.datetime :deleted_at
      t.integer :invoices_count, :default => 0
      t.integer :firm_id, :null => false
      t.timestamps
    end
    add_index :customers, :firm_id
  end

  def self.down
    drop_table :customers
  end
end
