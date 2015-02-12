class AddEmailsToForm < ActiveRecord::Migration
  def change
    add_column :forms, :emails, :json
  end
end
