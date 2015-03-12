class AddEmailCounterToQuote < ActiveRecord::Migration
  def change
    add_column :quotes, :email_sent, :integer, :default => 0
    add_column :quotes, :email_opened, :integer, :default => 0
  end
end
