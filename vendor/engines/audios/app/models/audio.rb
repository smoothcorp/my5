class Audio < ActiveRecord::Base

	acts_as_indexed :fields => [:title, :description, :url]

	validates :title, :presence => true, :uniqueness => true

	belongs_to :my_eq
	belongs_to :audio_program

	before_save :genereate_embed_code

	def genereate_embed_code
		self.embed_code = Wistia::Media.find_by_id(self.wistia_video_id).embed_code if !self.wistia_video_id.nil? && !self.wistia_video_id.blank?
	end

end
