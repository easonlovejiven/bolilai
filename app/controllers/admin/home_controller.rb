class Admin::HomeController < Admin::ApplicationController
  layout false

  def index
    @tody = DateTime.now.to_date.to_datetime
    ### 订单
    @all_trades = Shop::Trade.active
    @tody_trades = @all_trades.where("created_at >= ? ", @tody)
    @yestoday_trades = @all_trades.where("created_at >= ? and created_at <= ? ", @tody-1.day, @tody)
    @tody_pay_trades = @tody_trades.where(status: 'complete').where(["created_at > ?", 14.days.ago])
    @yestoday_pay_trades = @yestoday_trades.where(status: 'complete').where(["created_at > ?", 14.days.ago])
    @audit_trades = @all_trades.where(status: 'audit').where(["created_at > ?", 14.days.ago])
    @ship_trades = @all_trades.where(status: 'ship').where(["created_at > ?", 14.days.ago])
    ### 商品
    @online_products = Shop::Product.active.where(published: true)
    @offline_products = Shop::Product.active.where(published: false)
    @short_products = Shop::Product.select('count(shop_items.id) AS count_items, shop_products.id AS shop_products_id ')
                          .joins("LEFT JOIN `shop_items` ON `shop_items`.`product_id`=`shop_products`.`id` AND `shop_items`.`active`=1 AND `shop_items`.published=1 AND shop_items.trade_id is null")
                          .where(shop_products: {active: true, published: true})
                          .group('shop_products.id')
                          .having('count(shop_items.id) <1').to_a
    @product_items = Shop::Item.active.published.where('shop_items.trade_id is null')
    ### 会员信息
    @all_users = Shop::User
    @tody_users = @all_users.where("created_at >= ? ", @tody)
    @yestoday_users = @all_users.where("created_at >= ? and created_at <= ? ", @tody-1.day, @tody)
    ### 不能有layout
    render :index, layout: false
  end
end
