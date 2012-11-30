class CreateMiniModules < ActiveRecord::Migration

  def self.up
    create_table :mini_modules do |t|
      t.string :title
      t.text :description
      t.integer :position

      t.timestamps
    end

    add_index :mini_modules, :id

    load(Rails.root.join('db', 'seeds', 'mini_modules.rb'))
  end

  def self.down
    if defined?(UserPlugin)
      UserPlugin.destroy_all({:name => "mini_modules"})
    end

    if defined?(Page)
      Page.delete_all({:link_url => "/mini_modules"})
    end

    drop_table :mini_modules
  end

end
