class AddAcceptTAndCToCustomer < ActiveRecord::Migration
  def self.up
    add_column :customers, :accept_terms, :boolean
  end

  def self.down
    remove_column :customers, :accept_terms
  end
end
