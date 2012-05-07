class ChangeOccurenceSessionIdColumnType < ActiveRecord::Migration
  def self.up
    change_column(:occurences, :session_id, :string)
  end

  def self.down
    change_column(:occurences, :session_id, :integer)
  end
end
