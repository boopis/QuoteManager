class AddWrapperToForm < ActiveRecord::Migration
  def change
    add_column :forms, :wrapper, :string
    add_column :forms, :wrapper_content, :string
  end
end
