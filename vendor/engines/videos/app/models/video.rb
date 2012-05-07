class Video < ActiveRecord::Base

  acts_as_indexed :fields => [:title, :description, :url]

  validates :title, :presence => true
  validates_uniqueness_of :title, :scope => :symptomatic_id
  validates_uniqueness_of :title, :scope => :mini_module_id
  validate :validate_video_url
  
  belongs_to :symptomatic
  belongs_to :mini_module
  
  def validate_video_url
    # Setup valid variable
    valid = false
    # Add as many regex's as you want
    regexs  = [/http:\/\/(www\.)?vimeo.com\/(\d+)($|\/)/, /(?:www\.)?youtu(?:\.be|be\.com)\/(?:.*v(?:\/|=)|(?:.*\/)?)([a-zA-Z0-9\-\_]+)/]
    regexs.each do |reg|
      valid = (reg.match(self.url)) ? true : false
      break if valid
    end
    # Add an error if it's not valid
    errors.add(:url, "Your video URL is either incorrect or we don't support that format yet.") unless valid
  end
end
