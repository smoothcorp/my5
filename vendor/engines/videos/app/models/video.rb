class Video < ActiveRecord::Base

  acts_as_indexed :fields => [:title, :description]

  validates :title, :presence => true
  validates_uniqueness_of :title, :scope => :symptomatic_id
  validates_uniqueness_of :title, :scope => :mini_module_id
  
  belongs_to :symptomatic
  belongs_to :mini_module
  
end
