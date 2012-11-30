class CreateOccurences < ActiveRecord::Migration
  def self.up
    create_table :occurences do |t|
      t.integer :event_id
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :occurences
  end
end
