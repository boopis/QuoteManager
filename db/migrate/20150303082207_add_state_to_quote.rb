class AddStateToQuote < ActiveRecord::Migration
  def change
    add_column :quotes, :status, :string
  end
end
