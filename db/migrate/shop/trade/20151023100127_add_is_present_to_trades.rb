class AddIsPresentToTrades < ActiveRecord::Migration
  def change
    add_column :shop_trades,:is_present,:boolean,:default => false, :null => false
  end
end
