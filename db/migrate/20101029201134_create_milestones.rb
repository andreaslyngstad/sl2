class CreateMilestones < ActiveRecord::Migration
  def self.up
    create_table :milestones do |t|
      t.text :goal
      t.date :due
      t.integer :firm_id, :null => false
      t.boolean :completed
      t.integer :project_id

      t.timestamps
    end
    add_index :milestones, :firm_id
    add_index :milestones, :project_id
   

  end

  def self.down
    drop_table :milestones
  end
end
