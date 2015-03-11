class CreateTemplates < ActiveRecord::Migration
  def change
    create_table :templates do |t|
      t.string :name
      t.text :content
      t.text :description
      t.references :account, index: true

      t.timestamps
    end
  end
end
