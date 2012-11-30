class AddInvoiceNoToPayment < ActiveRecord::Migration
  def self.up
    add_column :payments, :invoice_no, :string
  end

  def self.down
    remove_column :payments, :invoice_no
  end
end
