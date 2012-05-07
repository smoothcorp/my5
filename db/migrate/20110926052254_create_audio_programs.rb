class CreateAudioPrograms < ActiveRecord::Migration

  def self.up
    create_table :audio_programs do |t|
      t.string :title
      t.text :description
      t.integer :position

      t.timestamps
    end

    add_index :audio_programs, :id

    load(Rails.root.join('db', 'seeds', 'audio_programs.rb'))
  end

  def self.down
    if defined?(UserPlugin)
      UserPlugin.destroy_all({:name => "audio_programs"})
    end

    if defined?(Page)
      Page.delete_all({:link_url => "/audio_programs"})
    end

    drop_table :audio_programs
  end

end
