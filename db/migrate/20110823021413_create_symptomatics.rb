class CreateSymptomatics < ActiveRecord::Migration

  def self.up
    create_table :symptomatics do |t|
      t.integer :body_part
      t.string :condition
      t.integer :position

      t.timestamps
    end

    add_index :symptomatics, :id

    load(Rails.root.join('db', 'seeds', 'symptomatics.rb'))
  end

  def self.down
    if defined?(UserPlugin)
      UserPlugin.destroy_all({:name => "symptomatics"})
    end

    if defined?(Page)
      Page.delete_all({:link_url => "/symptomatics"})
    end

    drop_table :symptomatics
  end

end
