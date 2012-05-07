class AddAudioForMyEqs < ActiveRecord::Migration
  def self.up
    add_column(:my_eqs, :audio_step_1, :string)
    add_column(:my_eqs, :audio_step_5, :string)
  end

  def self.down
    remove_column(:my_eqs, :audio_step_1)
    remove_column(:my_eqs, :audio_step_5)
  end
end
