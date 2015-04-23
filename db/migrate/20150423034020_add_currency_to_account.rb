class AddCurrencyToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :currency, :string
    add_column :quotes, :currency, :string
  end
end
