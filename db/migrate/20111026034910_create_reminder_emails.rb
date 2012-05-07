class CreateReminderEmails < ActiveRecord::Migration
  def self.up
    create_table :reminder_emails do |t|
      t.integer :customer_id
      t.integer :day

      t.timestamps
    end
  end

  def self.down
    drop_table :reminder_emails
  end
end
