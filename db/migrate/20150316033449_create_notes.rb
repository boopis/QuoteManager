class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.string :title
      t.text :content
      t.references :notable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
