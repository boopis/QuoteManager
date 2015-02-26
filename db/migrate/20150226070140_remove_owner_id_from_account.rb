class RemoveOwnerIdFromAccount < ActiveRecord::Migration
  def change
    remove_column :accounts, :owner_id, :integer
  end
end
