class AddFreeTrialRequestedToCustomers < ActiveRecord::Migration
  def self.up
  	add_column :customers, :free_trial_opted, :tinyint
  end

  def self.down
  	remove_column :customers, :free_trial_opted
  end
end
