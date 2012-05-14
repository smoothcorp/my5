class AddWistiaVideoIdToMediaEntities < ActiveRecord::Migration

	def self.up
		add_column :videos, :wistia_video_id, :string
		add_column :audios, :wistia_video_id, :string
		add_column :my_eqs, :audio_step_1_wistia_video_id, :string
		add_column :my_eqs, :audio_step_5_wistia_video_id, :string
	end

	def self.down
		remove_column :videos, :wistia_video_id
		remove_column :audios, :wistia_video_id
		remove_column :my_eqs, :audio_step_1_wistia_video_id
		remove_column :my_eqs, :audio_step_5_wistia_video_id
	end

end