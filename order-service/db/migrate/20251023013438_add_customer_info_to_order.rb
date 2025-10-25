class AddCustomerInfoToOrder < ActiveRecord::Migration[7.2]
  def change
    add_column :orders, :customer_info, :jsonb
  end
end
