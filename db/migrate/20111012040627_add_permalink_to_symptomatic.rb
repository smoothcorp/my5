class AddPermalinkToSymptomatic < ActiveRecord::Migration
  def self.up
    add_column(:symptomatics, :slug, :string)
  end

  def self.down
    remove_column(:symptomatics, :slug)
  end
end
