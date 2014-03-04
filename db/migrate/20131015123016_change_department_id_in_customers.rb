class ChangeDepartmentIdInCustomers < ActiveRecord::Migration
  def self.up
    change_column :customers, :department_id, :string
  end

  def self.down
    change_column :customers, :department_id, :integer
  end
end
