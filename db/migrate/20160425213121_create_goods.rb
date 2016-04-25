class CreateGoods < ActiveRecord::Migration
  def change
    create_table :goods do |t|
      t.string :name
      t.string :brand
      t.string :currency
      t.decimal :price
      t.text :description
      t.references :subscriber, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
