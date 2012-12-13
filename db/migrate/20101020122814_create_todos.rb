class CreateTodos < ActiveRecord::Migration
  def self.up
    create_table :todos do |t|
      t.text :name
      t.integer :user_id
      t.integer :firm_id, :null => false
      t.integer :project_id
      t.integer :customer_id
      t.integer :done_by_user_id
      t.date :due
      t.boolean :completed
      t.timestamps
    end
  end

  def self.down
    drop_table :todos
  end
end
