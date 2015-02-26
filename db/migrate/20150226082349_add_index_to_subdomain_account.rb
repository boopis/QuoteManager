class AddIndexToSubdomainAccount < ActiveRecord::Migration
  def up
    add_index :accounts, :subdomain
  end

  def down
    remove_index :accounts, :subdomain
  end
end
