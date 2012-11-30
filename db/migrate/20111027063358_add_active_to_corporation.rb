class AddActiveToCorporation < ActiveRecord::Migration
  def self.up
    add_column :corporations, :active, :boolean, :default => 1
  end

  def self.down
    remove_column :corporations, :active
  end
end
