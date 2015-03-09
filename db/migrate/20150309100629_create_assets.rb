class CreateAssets < ActiveRecord::Migration
  def change
    create_table :assets do |t|
      t.string :asset
      t.references :account, index: true
      t.references :request, index: true
      t.integer :public
      t.string :field_id

      t.timestamps
    end
  end
end
