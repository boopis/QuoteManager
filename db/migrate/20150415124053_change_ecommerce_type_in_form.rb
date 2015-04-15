class ChangeEcommerceTypeInForm < ActiveRecord::Migration
  def change
    rename_column :forms, :ecommerce_type, :trigger_method
  end
end
