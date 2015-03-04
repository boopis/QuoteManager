class AddPlanToAccounts < ActiveRecord::Migration
  def change
    add_reference :accounts, :plan, index: true
  end
end
