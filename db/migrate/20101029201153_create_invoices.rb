class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.integer   :number
      t.text      :content
      t.integer   :project_id
      t.integer   :customer_id, :null => false
      t.integer   :firm_id, :null => false
      t.integer   :status
      t.datetime  :reminder_sent
      t.datetime  :paid
      t.datetime  :due
      t.float     :total
      t.datetime  :date
      t.float     :discount
      t.text      :currency
      t.text      :mail_to
      t.text      :mail_subject
      t.text      :mail_content
      t.timestamps
    end
      add_index :invoices, :firm_id
      add_index :invoices, :project_id
      add_index :invoices, :customer_id
  end
end