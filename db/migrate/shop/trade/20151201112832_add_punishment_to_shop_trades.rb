class AddPunishmentToShopTrades < ActiveRecord::Migration
  def change
    add_column :shop_trades,:punishment,:integer
  end
end
