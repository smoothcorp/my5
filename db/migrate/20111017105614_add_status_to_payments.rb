class AddStatusToPayments < ActiveRecord::Migration
  def self.up
    add_column(:payments, :status, :integer, :default => 0)
  end

  def self.down
    remove_column(:payments, :status)
  end
end
