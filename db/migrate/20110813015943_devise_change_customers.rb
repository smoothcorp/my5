class DeviseChangeCustomers < ActiveRecord::Migration
  def self.up
    remove_column(:customers, :email)

    change_table(:customers) do |t|
      t.database_authenticatable :null => false
      t.recoverable
      t.rememberable
      t.trackable

      # t.encryptable
      # t.confirmable
      # t.lockable :lock_strategy => :failed_attempts, :unlock_strategy => :both
      # t.token_authenticatable
    end

    add_index :customers, :email,                :unique => true
    add_index :customers, :reset_password_token, :unique => true
    # add_index :customeras, :confirmation_token,   :unique => true
    # add_index :customeras, :unlock_token,         :unique => true
    # add_index :customeras, :authentication_token, :unique => true
  end

  def self.down
    drop_table :customers
  end
end
