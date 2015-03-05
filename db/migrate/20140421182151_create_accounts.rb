class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :company_name
      t.text :about
      t.text :address
      t.string :phone_number

      t.references :plan, index: true

      t.timestamps
    end
  end
end
