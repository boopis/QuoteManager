class AddSignatureToQuote < ActiveRecord::Migration
  def change
    add_column :quotes, :signature, :text
  end
end
