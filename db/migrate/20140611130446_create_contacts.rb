class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :name
      t.string :phone
      t.string :email

      t.references :account, index: true

      t.timestamps
    end
  end
end
