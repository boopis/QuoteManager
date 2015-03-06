class AddEcommerceTypeToForm < ActiveRecord::Migration
  def change
    add_column :forms, :ecommerce_type, :string
  end
end
