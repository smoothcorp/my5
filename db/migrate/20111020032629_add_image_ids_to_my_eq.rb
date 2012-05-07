class AddImageIdsToMyEq < ActiveRecord::Migration
  def self.up
    add_column :my_eqs, :image_id, :integer
  end

  def self.down
    remove_column :my_eqs, :image_id
  end
end
