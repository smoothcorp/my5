class AddSessionIdToOccurences < ActiveRecord::Migration
  def self.up
    add_column(:occurences, :session_id, :integer)
  end

  def self.down
    remove_column(:occurences, :session_id)
  end
end
