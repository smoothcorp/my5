class AddDescriptionToMyEqs < ActiveRecord::Migration
  def self.up
    add_column(:my_eqs, :description, :text)
    add_column(:my_eqs, :step_four, :text)
  end

  def self.down
    remove_column(:my_eqs, :description)
    remove_column(:my_eqs, :step_four)
  end
end
