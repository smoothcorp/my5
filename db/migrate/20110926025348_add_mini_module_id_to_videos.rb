class AddMiniModuleIdToVideos < ActiveRecord::Migration
  def self.up
    add_column(:videos, :mini_module_id, :integer)
  end

  def self.down
    remove_column(:videos, :mini_module_id)
  end
end
