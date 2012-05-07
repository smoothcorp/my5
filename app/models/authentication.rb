class Authentication < ActiveRecord::Base
  #Link to users
  belongs_to :user
  
  # Setup accessible (or protected) attributes for your model
  attr_accessible :user_id, :provider, :uid
end
