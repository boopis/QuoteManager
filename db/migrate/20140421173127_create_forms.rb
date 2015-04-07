class CreateForms < ActiveRecord::Migration
  def change
    create_table :forms do |t|
      t.string :name
      t.json :fields
      t.integer :column_style
      t.text :styles
      t.text :scripts
      t.json :emails 
      t.string :ecommerce_type
      t.text :thank_msg

      t.references :account, index: true

      t.timestamps
    end
  end
end
