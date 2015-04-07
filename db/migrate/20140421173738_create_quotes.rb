class CreateQuotes < ActiveRecord::Migration
  def change
    create_table :quotes do |t|
      t.decimal :amount, precision: 10, scale: 2
      t.json :options
      t.string :token
      t.timestamp :expires_at
      t.belongs_to :request, index: true
      t.text :description
      t.text :signature
      t.integer :email_sent, default: 0
      t.integer :email_opened, default: 0

      t.references :account, index: true
      t.references :template, index: true

      t.timestamps
    end
  end
end
