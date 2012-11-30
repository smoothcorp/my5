class Bodypart < ActiveRecord::Base
  has_one :symptomatic
  has_many :videos, :through => :symptomatic, :foreign_key => "body_part"
end
