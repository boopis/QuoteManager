class AddThankMsgToForm < ActiveRecord::Migration
  def change
    add_column :forms, :thank_msg, :text
  end
end
