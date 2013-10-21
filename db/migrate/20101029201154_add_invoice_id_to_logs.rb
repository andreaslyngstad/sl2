class AddInvoiceIdToLogs < ActiveRecord::Migration
  def change
  	add_reference :logs, :invoice, index: true
  end
end
