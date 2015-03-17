class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :address_line_1
      t.string :address_line_2
      t.string :city
      t.string :postal_code
      t.string :state

      t.references :addressable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
