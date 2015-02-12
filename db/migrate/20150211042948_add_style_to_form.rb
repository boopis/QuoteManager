class AddStyleToForm < ActiveRecord::Migration
  def change
    add_column :forms, :styles, :text
  end
end
