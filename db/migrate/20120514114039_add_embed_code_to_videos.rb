class AddEmbedCodeToVideos < ActiveRecord::Migration
  def self.up
 	add_column :videos, :embed_code, :text
  end

  def self.down
  	remove_column :videos, :embed_code
  end
end
