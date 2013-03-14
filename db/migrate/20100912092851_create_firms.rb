class CreateFirms < ActiveRecord::Migration
  def self.up
    create_table :firms do |t|
           t.string :name
           t.string :subdomain
           t.string :address
           t.string :phone
           t.string :currency
           t.string :language
           t.string :time_zone
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
