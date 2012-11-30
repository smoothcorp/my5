class Video < ActiveRecord::Base

	acts_as_indexed :fields => [:title, :description]

	validates :title, :presence => true
	validates_uniqueness_of :title, :scope => :symptomatic_id
	validates_uniqueness_of :title, :scope => :mini_module_id

	belongs_to :symptomatic
	belongs_to :mini_module

	before_save :genereate_embed_code

	def genereate_embed_code
		self.embed_code = Wistia::Media.find_by_id(self.wistia_video_id).embed_code if !self.wistia_video_id.nil? && !self.wistia_video_id.blank? 
	end
end
