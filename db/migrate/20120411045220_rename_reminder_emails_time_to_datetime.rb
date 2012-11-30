class RenameReminderEmailsTimeToDatetime < ActiveRecord::Migration
  def self.up
    change_column(:reminder_emails, :time, :datetime)
  end

  def self.down
    change_column(:reminder_emails, :time, :time)
  end
end
