class AddState2ToCustomers < ActiveRecord::Migration
  def self.up
    add_column :customers, :state2, :string
  end

  def self.down
    remove_column :customers, :state2
  end
end
