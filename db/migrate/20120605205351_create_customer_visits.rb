class CreateCustomerVisits < ActiveRecord::Migration
  def self.up
    create_table :customer_visits do |t|
      t.string :session_id
      t.string :controller_name
      t.string :action_name
      t.integer :customer_id
      t.integer :show_id
      t.string :conditions
      t.integer :media_id
      t.integer :part
      t.timestamps
    end
  end

  def self.down
    drop_table :customer_visits
  end
end
