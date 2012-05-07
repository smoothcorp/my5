class CreateBodyparts < ActiveRecord::Migration
  def self.up
    create_table :bodyparts do |t|
      t.string :title

      t.timestamps
    end
  end

  def self.down
    drop_table :bodyparts
  end
end
