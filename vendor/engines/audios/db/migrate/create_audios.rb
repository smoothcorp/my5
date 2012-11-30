class CreateAudios < ActiveRecord::Migration

  def self.up
    create_table :audios do |t|
      t.string :title
      t.text :description
      t.string :url
      t.integer :my_eq_id
      t.integer :position

      t.timestamps
    end

    add_index :audios, :id

    load(Rails.root.join('db', 'seeds', 'audios.rb'))
  end

  def self.down
    if defined?(UserPlugin)
      UserPlugin.destroy_all({:name => "audios"})
    end

    if defined?(Page)
      Page.delete_all({:link_url => "/audios"})
    end

    drop_table :audios
  end

end
