class AddDepartmentIdToCustomersTable < ActiveRecord::Migration
  def self.up
    add_column(:customers, :department_id, :integer)
  end

  def self.down
    remove_column(:customers, :department_id)
  end
end