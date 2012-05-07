class AddPositionToPages < ActiveRecord::Migration
  def self.up
    add_column :pages, :custom_position, :integer
  end

  def self.down
    remove_column :pages, :custom_position
  end
end
