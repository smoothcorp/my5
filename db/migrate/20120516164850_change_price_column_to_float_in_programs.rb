class ChangePriceColumnToFloatInPrograms < ActiveRecord::Migration
  def self.up
  	change_column :programs, :price, :float, :precision => 4, :scale => 2
  end

  def self.down
  	change_column :programs, :price, :decimal
  end
end
