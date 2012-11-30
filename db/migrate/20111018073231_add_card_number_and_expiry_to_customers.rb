class AddCardNumberAndExpiryToCustomers < ActiveRecord::Migration
  def self.up
    add_column(:customers, :card_number, :string)
    add_column(:customers, :card_expiry_date, :string)
  end

  def self.down
    remove_column(:customers, :card_number)
    remove_column(:customers, :card_expiry_date)
  end
end
