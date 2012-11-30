class Program < ActiveRecord::Base

  # def title was created automatically because you didn't specify a string field
  # when you ran the refinery_engine generator. Love, Refinery CMS.

  validates :price, :presence => true

  def title
    "Program"
  end
  
  def self.second
     sec = self.where(:id.gt=>self.first.id)
     if sec.blank?
         pr = self.first
     else
         pr = sec.first
     end
     return pr
  end
  
end
