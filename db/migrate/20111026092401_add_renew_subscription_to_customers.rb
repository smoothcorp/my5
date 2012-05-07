class AddRenewSubscriptionToCustomers < ActiveRecord::Migration
  def self.up
    add_column(:customers, :renew_subscription, :boolean, :default => true)
  end

  def self.down
    remove_column(:customers, :renew_subscription)
  end
end
