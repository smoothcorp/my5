class MyEq < ActiveRecord::Base

  acts_as_indexed :fields => [:emotional_grouping, :step_two, :step_three, :description]

  validates :emotional_grouping, :presence => true, :uniqueness => true

  attr_accessible :image_id, :emotional_grouping, :description, :step_two, :step_three, :step_four, 
    :audio_step_1, :audio_step_5, :audio_step_1_embed_code, :audio_step_5_embed_code
  belongs_to :image
  has_many :audios

  STEPS = ["Stop! Take a breath in", "Pressure point", "Personal inventory", "Design a strategy", "Breathe it out"]
  IMAGES = ["my_eqs/head.png", "my_eqs/head.png", "my_eqs/step3.png", "my_eqs/step4.png", "my_eqs/head.png"]

  def self.steps
      return STEPS
  end

  def self.images
      return IMAGES
  end

end
