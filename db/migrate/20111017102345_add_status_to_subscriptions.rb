class AddStatusToSubscriptions < ActiveRecord::Migration
  def self.up
    add_column(:subscriptions, :status, :integer, :default => 0)
  end

  def self.down
    remove_column(:subscriptions, :status)
  end
end
