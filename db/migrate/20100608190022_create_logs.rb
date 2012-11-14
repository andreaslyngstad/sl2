class CreateLogs < ActiveRecord::Migration
  def self.up
    create_table :logs do |t|
      t.string :event
      t.integer :customer_id
      t.integer :user_id, :null => false
      t.integer :firm_id, :null => false
      t.integer :project_id
      t.integer :employee_id
      t.integer :todo_id
      t.boolean :tracking
      t.datetime :begin_time
      t.datetime :end_time
      t.date :log_date
      t.float :hours
      t.timestamps
    end
  end

  def self.down
    drop_table :logs
  end
end
