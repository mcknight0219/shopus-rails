class ChangeExpressMethodsRateColumnType < ActiveRecord::Migration
  def change
    change_column(:express_methods, :rate, :float)
  end
end
