class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.string :invoice_number
      t.string :content
      t.integer :project_id
      t.integer :customer_id
      t.integer :firm_id, :null => false
      t.boolean :paid
      t.boolean :reminder_sent

      t.timestamps
    end
  end
end
