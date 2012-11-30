class CreateCorporations < ActiveRecord::Migration

  def self.up
    create_table :corporations do |t|
      t.string :name, :nullable => false
      t.integer :logo_id
      t.integer :position

      t.timestamps
    end

    add_index :corporations, :id

    load(Rails.root.join('db', 'seeds', 'corporations.rb'))
  end

  def self.down
    if defined?(UserPlugin)
      UserPlugin.destroy_all({:name => "corporations"})
    end

    if defined?(Page)
      Page.delete_all({:link_url => "/corporations"})
    end

    drop_table :corporations
  end

end
