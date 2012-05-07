class CreateCustomers < ActiveRecord::Migration

  def self.up
    create_table :customers do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :contact_phone
      t.string :address
      t.string :role
      t.integer :corporation_id
      t.integer :position

      t.timestamps
    end

    add_index :customers, :id

    load(Rails.root.join('db', 'seeds', 'customers.rb'))
  end

  def self.down
    if defined?(UserPlugin)
      UserPlugin.destroy_all({:name => "customers"})
    end

    if defined?(Page)
      Page.delete_all({:link_url => "/customers"})
    end

    drop_table :customers
  end

end
