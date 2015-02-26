class AddAccountIdToRequest < ActiveRecord::Migration
  def change
    add_column :requests, :account_id, :integer
  end
end
