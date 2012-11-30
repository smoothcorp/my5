class CreateHealthCheckins < ActiveRecord::Migration
  def self.up
    create_table :health_checkins do |t|
      t.integer :stress_rating
      t.integer :energy_rating
      t.integer :comfort_rating
      t.integer :customer_id

      t.timestamps
    end
  end

  def self.down
    drop_table :health_checkins
  end
end
