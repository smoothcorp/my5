class ChangeAccessToPlanInSubscriptions < ActiveRecord::Migration
  def self.up
    remove_column(:subscriptions, :access)
    add_column(:subscriptions, :plan, :integer, :default => 1)
  end

  def self.down
    remove_column(:subscriptions, :plan)
    add_column(:subscriptions, :access, :integer, :default => 1)
  end
end
