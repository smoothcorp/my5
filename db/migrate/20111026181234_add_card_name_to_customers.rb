class AddCardNameToCustomers < ActiveRecord::Migration
  def self.up
    add_column :customers, :card_name, :string
  end

  def self.down
    remove_column :customers, :card_name
  end
end
