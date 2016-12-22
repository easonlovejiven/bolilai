class Mobile::TradesController < Mobile::ApplicationController
  def index
    params[:where]||={}
    params[:where][:status]=params[:status].split(",")  if !params[:status].blank?
    @trades = @current_user.trades.active._where(params[:where])._order(params[:order]).page(params[:page]).per(params[:per_page] || 10)
    # if params[:status]=="receive"
    #   render "confirm"
    # else
      render "index"
    # end
  end

  def new
    @trade = Shop::Trade.new
    @cart = ActiveSupport::JSON.decode((@current_user ? @current_user.reload.cart_data : session[:cart_data]) || '[]') rescue []
    @cart ||= []
    @total_price=0
    @cart.reverse.each_with_index do |unit, i|
      product = Shop::Product.acquire(unit['product_id'])
      @total_price+= product.discount
    end
    @trade.contact = @current_user && @current_user.contacts.active.order("created_at DESC").first || Shop::Contact.new
    @vouchers=@current_user.vouchers.active.joins('JOIN shop_events ON shop_events.id = shop_vouchers.event_id AND shop_events.started_at < NOW() AND shop_events.ended_at > NOW()').where('shop_vouchers.trade_id IS NULL').order('shop_vouchers.id DESC').limit(30) if @current_user
    respond_to do |format|
      format.html { @enable_lazyload = false }
      format.xml { @data = {'units' => @cart.map { |u| Unit.new(u) }.assign_options(:only => [:percent], :methods => [:product_id, :measure, :quantity])} }
    end
  end

  def show
    @trade = Shop::Trade.acquire(params[:id])

    respond_to do |format|
      format.html { @enable_lazyload = false }
      format.xml { @data = { 'trade' => @current_user && @trade.user_id == @current_user.id ? @trade : @trade.assign_options(Shop::Trade.others_to_pay_xml_options) } }
    end
  end

  def paymode
    @trade = Shop::Trade.acquire(params[:id])
  end

  def current_app
    @current_app ||= AUCTION_APP
  end

end
