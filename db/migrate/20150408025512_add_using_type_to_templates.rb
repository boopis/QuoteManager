class AddUsingTypeToTemplates < ActiveRecord::Migration
  def change
    add_column :templates, :using_type, :string
  end
end
