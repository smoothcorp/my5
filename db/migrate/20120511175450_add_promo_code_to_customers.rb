class AddPromoCodeToCustomers < ActiveRecord::Migration
  def self.up
  	add_column :customers, :promo_code, :string
  end

  def self.down
  	remove_column :customers, :promo_code
  end
end
