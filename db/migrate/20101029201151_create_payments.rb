class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :firm_id
      t.float :amount
      t.text :plan_name
      t.text :card_type
      t.text :last_four
      t.timestamps
    end
  end
end
