class AddAudioProgramIdToAudios < ActiveRecord::Migration
  def self.up
    add_column(:audios, :audio_program_id, :integer)
  end

  def self.down
    remove_column(:audios, :audio_program_id)
  end
end
