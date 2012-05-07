class CreateSubscriptions < ActiveRecord::Migration

  def self.up
    create_table :subscriptions do |t|
      t.integer :customer_id
      t.datetime :expiry_date
      t.integer :access
      t.integer :position

      t.timestamps
    end

    add_index :subscriptions, :id

    load(Rails.root.join('db', 'seeds', 'subscriptions.rb'))
  end

  def self.down
    if defined?(UserPlugin)
      UserPlugin.destroy_all({:name => "subscriptions"})
    end

    if defined?(Page)
      Page.delete_all({:link_url => "/subscriptions"})
    end

    drop_table :subscriptions
  end

end
