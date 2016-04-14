class CreateSubscribers < ActiveRecord::Migration
  def change
    create_table :subscribers do |t|
      t.string :weixin
      t.boolean :active
      t.boolean :is_seller

      t.timestamps null: false
    end
  end
end
