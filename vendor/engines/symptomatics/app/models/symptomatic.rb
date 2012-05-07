class Symptomatic < ActiveRecord::Base
  make_permalink :with => :condition, :field => :slug
  acts_as_indexed :fields => [:condition]
  validates :condition, :presence => true, :uniqueness => true
  has_many :videos
  belongs_to :bodypart, :foreign_key => "body_part"
  
  BPARTS = ["Head", "Neck", "Shoulder", "Arms", "Legs", "Back"]
  
  def summary
      return "#{self.bodypart.title} - #{self.condition}"
  end
  
  def body_part_name
    self.bodypart.nil? ? false : self.bodypart.title
    #return BPARTS[self.body_part].blank? ? false : BPARTS[self.body_part] 
  end
  
  def self.body_parts
    return Bodypart.all.collect(&:title)
    #return BPARTS
  end
  
  def self.body_part_name(id)
    return BPARTS[id].blank? ? false : BPARTS[id] 
  end
end
