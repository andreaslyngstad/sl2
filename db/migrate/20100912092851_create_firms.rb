class CreateFirms < ActiveRecord::Migration
  def self.up
    create_table :firms do |t|
           t.text :name
           t.text :subdomain
           t.text :address
           t.text :phone
           t.text :currency
           t.text :language
           t.text :time_zone
           t.boolean :closed
           t.integer :time_format
           t.integer :date_format
           t.integer :clock_format
           t.integer :plan_id
           t.integer :customers_count, :default => 0
           t.integer :users_count, :default => 0
           t.integer :projects_count, :default => 0
           t.integer :logs_count, :default => 0  
           
      t.timestamps
    end
     add_index :firms, :plan_id
     add_index :firms, :subdomain
  end

  def self.down
    drop_table :firms
  end
end
