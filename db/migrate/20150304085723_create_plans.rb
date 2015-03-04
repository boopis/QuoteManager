class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string :name
      t.decimal :price
      t.integer :users
      t.integer :forms
      t.integer :storage
      t.integer :requests

      t.timestamps
    end
  end
end
