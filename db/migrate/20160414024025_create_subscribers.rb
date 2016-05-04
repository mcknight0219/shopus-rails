class CreateSubscribers < ActiveRecord::Migration
  def change
    create_table :subscribers do |t|
      t.string :weixin
      t.boolean :is_seller, :null => :no

      t.timestamps null: false
    end
  end
end
