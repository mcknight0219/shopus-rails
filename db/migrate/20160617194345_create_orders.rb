class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :state
      t.references :good, index: true, foreign_key: true
      t.double :price
      t.double :extra
      t.double :shipping_cost

      t.timestamps null: false
    end
  end
end
