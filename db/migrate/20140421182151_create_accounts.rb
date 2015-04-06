class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :company_name
      t.text :about
      t.string :phone_number
      t.string :stripe_customer_token
      t.string :stripe_subscription_token
      t.integer :storage_usage

      t.references :plan, index: true

      t.timestamps
    end
  end
end
