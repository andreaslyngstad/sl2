class CreateMemberships < ActiveRecord::Migration
  def self.up
    create_table :memberships do |t|
      t.integer :project_id
      t.integer :user_id

      t.timestamps
    end
    add_index :memberships, [:project_id, :user_id], :unique => true
  end

  def self.down
    drop_table :memberships
  end
end
