class AddStorageUsageToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :storage_usage, :integer
  end
end
