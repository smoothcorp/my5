class MyEq < ActiveRecord::Base

  STEPS = ["Stop! Take a breath in", "Pressure point", "Personal inventory", "Design a strategy", "Breathe it out"]
  IMAGES = ["my_eqs/head.png", "my_eqs/head.png", "my_eqs/step3.png", "my_eqs/step4.png", "my_eqs/head.png"]

  acts_as_indexed :fields => [:emotional_grouping, :step_two, :step_three, :description]

  validates :emotional_grouping, :presence => true, :uniqueness => true

  attr_accessible :image_id, :emotional_grouping, :description, :step_two, :step_three, :step_four, 
    :audio_step_1, :audio_step_5, :audio_step_1_embed_code, :audio_step_5_embed_code, :audio_step_1_wistia_video_id,
    :audio_step_5_wistia_video_id

  belongs_to :image
  has_many :audios

  before_save :genereate_embed_codes

  def self.steps
      return STEPS
  end

  def self.images
      return IMAGES
  end

  def genereate_embed_codes
    self.audio_step_1_embed_code = 
      Wistia::Media.find_by_id(self.audio_step_1_wistia_video_id).embed_code unless self.audio_step_1_wistia_video_id.nil?
    self.audio_step_5_embed_code = 
      Wistia::Media.find_by_id(self.audio_step_5_wistia_video_id).embed_code unless self.audio_step_5_wistia_video_id.nil?
  end

end
