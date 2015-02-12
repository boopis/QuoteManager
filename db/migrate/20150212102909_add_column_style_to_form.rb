class AddColumnStyleToForm < ActiveRecord::Migration
  def change
    add_column :forms, :column_style, :integer
  end
end
