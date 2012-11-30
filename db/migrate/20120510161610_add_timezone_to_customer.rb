class AddTimezoneToCustomer < ActiveRecord::Migration
	def self.up
		add_column :customers, :time_zone, :string, :null => false, :default => "Sydney"
	end

	def self.down
		remove_column :customers, :time_zone
	end
end
