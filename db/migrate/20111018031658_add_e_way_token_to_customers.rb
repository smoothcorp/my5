class AddEWayTokenToCustomers < ActiveRecord::Migration
  def self.up
    add_column(:customers, :eway_token, :string)
  end

  def self.down
    remove_column(:customers, :eway_token)
  end
end
