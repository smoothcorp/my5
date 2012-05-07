class Audio < ActiveRecord::Base

  acts_as_indexed :fields => [:title, :description, :url]

  validates :title, :presence => true, :uniqueness => true

  belongs_to :my_eq
  belongs_to :audio_program
end
