class RemoveAddressFromAccount < ActiveRecord::Migration
  def change
    remove_column :accounts, :address, :text
  end
end
