class CreateInvoiceLines < ActiveRecord::Migration
  def change
    create_table :invoice_lines do |t|
      t.float :quantity
      t.text :description
      t.float :price
      t.float :amount
      t.float :tax
      t.integer :invoice_id
      t.timestamps
    end
  end
end
