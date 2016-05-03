class CreateExpressMethods < ActiveRecord::Migration
  def change
    create_table :express_methods do |t|
      t.string :company
      t.integer :unit
      t.decimal :rate
      t.string :country
      t.integer :duration
      t.text :description
      t.references :subscriber, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
