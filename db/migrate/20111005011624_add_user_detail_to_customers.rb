class AddUserDetailToCustomers < ActiveRecord::Migration
  def self.up
    add_column(:customers, :street_1, :string)
    add_column(:customers, :street_2, :string)
    add_column(:customers, :city, :string)
    add_column(:customers, :state, :string)
    add_column(:customers, :country, :string)
    add_column(:customers, :zip_code, :string)
  end

  def self.down
    remove_column(:customers, :street_1)
    remove_column(:customers, :street_2)
    remove_column(:customers, :city)
    remove_column(:customers, :state)
    remove_column(:customers, :country)
    remove_column(:customers, :zip_code)
  end
end
