class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string :paymill_id
      t.string :name
      t.float :price
      t.integer :customers
      t.integer :logs
      t.integer :projects
      t.integer :users
      t.integer :firms_count, :default => 0
      t.integer :subscriptions_count, :default => 0
      t.timestamps
    end
  end
end