class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :image
      t.references :viewable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
