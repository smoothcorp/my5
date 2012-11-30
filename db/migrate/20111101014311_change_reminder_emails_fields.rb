class ChangeReminderEmailsFields < ActiveRecord::Migration
  def self.up
    add_column(:reminder_emails, :time, :time)
    remove_column(:reminder_emails, :day)
    add_column(:reminder_emails, :days_of_week, :string)
  end

  def self.down
    remove_column(:reminder_emails, :time)
    add_column(:reminder_emails, :day, :integer)
    remove_column(:reminder_emails, :days_of_week)
  end
end
