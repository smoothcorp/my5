class AddCustomerIdToModels < ActiveRecord::Migration
  def self.up
    add_column(:activities, :customer_id, :integer)
    add_column(:transactions, :customer_id, :integer)
  end

  def self.down
    remove_column(:activities, :customer_id)
    remove_column(:transactions, :customer_id)
  end
end
