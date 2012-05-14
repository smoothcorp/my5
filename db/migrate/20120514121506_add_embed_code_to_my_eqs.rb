class AddEmbedCodeToMyEqs < ActiveRecord::Migration
  def self.up
 	add_column :my_eqs, :audio_step_1_embed_code, :text
 	add_column :my_eqs, :audio_step_5_embed_code, :text
  end

  def self.down
  	remove_column :my_eqs, :audio_step_1_embed_code
  	remove_column :my_eqs, :audio_step_5_embed_code
  end
end
