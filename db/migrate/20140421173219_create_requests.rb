class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.json :fields
      t.belongs_to :form, index: true
      t.string :status

      t.references :account, index: true
      t.references :contact, index: true

      t.timestamps
    end
  end
end
