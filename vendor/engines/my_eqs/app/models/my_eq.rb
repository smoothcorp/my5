class MyEq < ActiveRecord::Base
  VIMEO_REGEX = /^(?:http:\/\/)?(?:www\.)?vimeo\.com\/(\d+)/

  acts_as_indexed :fields => [:emotional_grouping, :step_two, :step_three, :description]

  validates :emotional_grouping, :presence => true, :uniqueness => true
  validates_format_of :audio_step_1, :with => /^(?:http:\/\/)?(?:www\.)?vimeo\.com\/(\d+)/, :allow_blank => true

  attr_accessible :image_id, :emotional_grouping, :description, :step_two, :step_three, :step_four, :audio_step_1, :audio_step_5
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
