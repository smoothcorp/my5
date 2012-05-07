class AddStatusColumnToHealthCheckins < ActiveRecord::Migration
  def self.up
    add_column :health_checkins, :status, :integer
  end

  def self.down
    remove_column :health_checkins, :status
  end
end
