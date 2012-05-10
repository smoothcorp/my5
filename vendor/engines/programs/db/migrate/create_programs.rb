class CreatePrograms < ActiveRecord::Migration

  def self.up
    create_table :programs do |t|
      t.decimal :price
      t.integer :position

      t.timestamps
    end

    add_index :programs, :id

    load(Rails.root.join('db', 'seeds', 'programs.rb'))
  end

  def self.down
    if defined?(UserPlugin)
      UserPlugin.destroy_all({:name => "programs"})
    end

    if defined?(Page)
      Page.delete_all({:link_url => "/programs"})
    end

    drop_table :programs
  end

end
