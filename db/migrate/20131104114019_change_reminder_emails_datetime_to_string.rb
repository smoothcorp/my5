class ChangeReminderEmailsDatetimeToString < ActiveRecord::Migration
  def self.up
    add_column(:reminder_emails, :string_time, :string)

    ReminderEmail.all.each do |reminder|
      next unless reminder.customer

      hours   = reminder.time.utc.strftime("%H").to_i
      minutes = reminder.time.utc.strftime("%M").to_i

      Time.zone    = reminder.customer.time_zone
      hours_offset = Time.zone.utc_offset / 60 / 60

      minutes_offset = Time.zone.utc_offset % 60

      hours   += hours_offset
      minutes += minutes_offset

      hours -= 1 unless reminder.created_at.dst?

      hours -= 24 if hours > 23

      reminder.string_time = hours.to_s + ':' + minutes.to_s
      reminder.save
    end

  end

  def self.down
    remove_column(:reminder_emails, :string_time)
  end

end
