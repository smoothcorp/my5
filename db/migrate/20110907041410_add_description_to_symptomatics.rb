class AddDescriptionToSymptomatics < ActiveRecord::Migration
  def self.up
      add_column(:symptomatics, :description, :text)
  end

  def self.down
      remove_column(:symptomatics, :description)
  end
end
