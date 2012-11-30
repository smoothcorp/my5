class RemoveAcceptTermsFromCustomers < ActiveRecord::Migration
  def self.up
    remove_column :customers, :accept_terms
  end

  def self.down
    add_column :customers, :accept_terms, :boolean
  end
end
