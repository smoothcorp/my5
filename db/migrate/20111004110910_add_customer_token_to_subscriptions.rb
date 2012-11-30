class AddCustomerTokenToSubscriptions < ActiveRecord::Migration
  def self.up
    add_column(:subscriptions, :customer_token, :string)
  end

  def self.down
    remove_column(:subscriptions, :customer_token)
  end
end
