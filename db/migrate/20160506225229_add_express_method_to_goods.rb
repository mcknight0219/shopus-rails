class AddExpressMethodToGoods < ActiveRecord::Migration
  def change
    add_reference :goods, :express_method, index: true, foreign_key: true
  end
end
