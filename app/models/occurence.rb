class Occurence < ActiveRecord::Base
  belongs_to :event
  belongs_to :customer, :foreign_key => 'user_id'
end
