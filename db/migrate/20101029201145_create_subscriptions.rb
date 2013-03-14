class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.integer :plan_id
      t.string :email
      t.string :name
      t.integer :firm_id
      t.string :paymill_id
      t.string  :card_zip
      t.string  :last_four
      t.string  :card_type
      t.date    :next_bill_on
      t.string  :card_expiration
      t.string  :card_holder
      t.boolean :active

      t.timestamps
    end
    add_index :subscriptions, [:plan_id, :firm_id]
  end
  
end