class ChangeFieldsQuote < ActiveRecord::Migration
  def change
    add_column :quotes, :description, :text
    rename_column :quotes, :terms, :options
  end
end
