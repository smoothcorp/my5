class CreateVideos < ActiveRecord::Migration

  def self.up
    create_table :videos do |t|
      t.string :title
      t.text :description
      t.string :url
      t.integer :symptomatic_id
      t.integer :position

      t.timestamps
    end

    add_index :videos, :id

    load(Rails.root.join('db', 'seeds', 'videos.rb'))
  end

  def self.down
    if defined?(UserPlugin)
      UserPlugin.destroy_all({:name => "videos"})
    end

    if defined?(Page)
      Page.delete_all({:link_url => "/videos"})
    end

    drop_table :videos
  end

end
