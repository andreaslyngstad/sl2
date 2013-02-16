class CreateStatistics < ActiveRecord::Migration
  def change
    create_table :statistics do |t|
      t.integer :firms
      t.integer :users
      t.integer :free
      t.integer :bronze
      t.integer :silver
      t.integer :gold
      t.integer :platinum
      t.integer :logs
      t.integer :customers
      t.integer :projects
      t.timestamps
    end
  end
end
