class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :name
      t.string :phone
      t.string :email
      t.string :title
      t.text :description

      t.references :account, index: true

      t.timestamps
    end
  end
end
