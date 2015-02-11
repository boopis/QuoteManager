class AddScriptToForm < ActiveRecord::Migration
  def change
    add_column :forms, :scripts, :text
  end
end
