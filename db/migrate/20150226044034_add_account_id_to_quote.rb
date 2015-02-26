class AddAccountIdToQuote < ActiveRecord::Migration
  def change
    add_column :quotes, :account_id, :integer
  end
end
