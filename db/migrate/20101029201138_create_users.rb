class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
	    t.string  :role
      t.string 	:phone
      t.string 	:name
      t.integer :firm_id, :null => false
      t.float   :hourly_rate
      t.timestamps
      t.string :loginable_type, :limit => 40
      t.integer :loginable_id
      t.string :loginable_token
    end
    add_index :users, :firm_id
   
  end

  def self.down
    drop_table :users
  end
end
