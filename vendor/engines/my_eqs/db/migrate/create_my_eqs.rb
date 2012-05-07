class CreateMyEqs < ActiveRecord::Migration

  def self.up
    create_table :my_eqs do |t|
      t.string :emotional_grouping
      t.text :step_two
      t.text :step_three
      t.integer :position

      t.timestamps
    end

    add_index :my_eqs, :id

    load(Rails.root.join('db', 'seeds', 'my_eqs.rb'))
  end

  def self.down
    if defined?(UserPlugin)
      UserPlugin.destroy_all({:name => "my_eqs"})
    end

    if defined?(Page)
      Page.delete_all({:link_url => "/my_eqs"})
    end

    drop_table :my_eqs
  end

end
