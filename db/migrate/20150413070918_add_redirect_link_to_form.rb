class AddRedirectLinkToForm < ActiveRecord::Migration
  def change
    add_column :forms, :redirect_link, :string
  end
end
