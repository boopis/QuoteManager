class AddAccountIdToForm < ActiveRecord::Migration
  def change
    add_column :forms, :account_id, :integer
  end
end
