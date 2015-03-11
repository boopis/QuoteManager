class AddStripeSubscriptionTokenToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :stripe_subscription_token, :string
  end
end
