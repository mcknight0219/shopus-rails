class ChangeGoodsPriceColumnType < ActiveRecord::Migration
  def change
    change_column(:goods, :price, :float)
  end
end
