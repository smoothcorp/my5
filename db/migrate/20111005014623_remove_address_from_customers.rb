class RemoveAddressFromCustomers < ActiveRecord::Migration
  def self.up
    remove_column(:customers, :address)
  end

  def self.down
    add_column(:customers, :address, :string)
  end
end
