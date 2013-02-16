class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.integer :plan_id
      t.string :email
      t.string :name
      t.integer :firm_id
      t.string :paymill_id

      t.timestamps
    end
    add_index :subscriptions, [:plan_id, :firm_id], :unique => true
  end
  
end