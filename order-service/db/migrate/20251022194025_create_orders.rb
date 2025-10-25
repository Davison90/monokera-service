class CreateOrders < ActiveRecord::Migration[7.2]
  def change
    create_table :orders do |t|
      t.integer :customer_id, null: false
      t.string :product_name
      t.integer :quantity
      t.float :price
      t.boolean :status, default: true

      t.timestamps
    end
  end
end
