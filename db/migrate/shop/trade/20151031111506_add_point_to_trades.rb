class AddPointToTrades < ActiveRecord::Migration
  def change
    add_column :shop_trades,:point,:integer
  end
end
