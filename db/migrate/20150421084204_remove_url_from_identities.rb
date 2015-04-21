class RemoveUrlFromIdentities < ActiveRecord::Migration
  def change
    remove_column :identities, :url, :string
  end
end
