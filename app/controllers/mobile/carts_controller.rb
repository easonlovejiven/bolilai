class Mobile::CartsController < Mobile::ApplicationController
  def index
    @trade = Shop::Trade.new
    @cart = ActiveSupport::JSON.decode((@current_user ? @current_user.reload.cart_data : session[:cart_data]) || '[]') rescue []
    @cart ||= []
    @total_price=0
    @cart.reverse.each_with_index do |unit, i|
      product = Shop::Product.acquire(unit['product_id'])
      @total_price+= product.discount
    end
    respond_to do |format|
      format.html { @enable_lazyload = false }
      format.xml { @data = {'retail_carts' => @cart.map{|u| Shop::Unit.new(u) }.assign_options(:only => [:percent], :methods => [:product_id, :measure, :quantity]) } }
    end
  end

  def show
    @cart = ActiveSupport::JSON.decode((@current_user ? @current_user.reload.cart_data : session[:cart_data]) || '[]') rescue []
    respond_to do |format|
      format.html { @enable_lazyload = false }
      format.xml { @data = { 'retail_carts' => @cart.map{|u| Shop::Unit.new(u) }.assign_options(:only => [:percent], :methods => [:product_id, :measure, :quantity]) } }
    end
  end

  def create
    unit = params.require(:retail_cart).permit!
    @cart = ActiveSupport::JSON.decode((@current_user ? @current_user.cart_data : session[:cart_data]) || '[]') rescue []
    @cart ||= []
    @cart << unit unless @cart.find{|u| u['product_id'] == unit['product_id'] && u['measure'] == unit['measure'] }

    if @current_user
      @current_user.update_attributes(:cart_data => @cart.to_json)
    else
      session[:cart_data] = @cart.to_json
    end

    respond_to do |format|
      format.html { redirect_to params[:redirect] || new_shop_trade_path }
      format.xml { render :json=>{ 'units' => @cart.map{|u| Shop::Unit.new(u) }.assign_options(:only => [:percent], :methods => [:product_id, :measure, :quantity]) } }
    end
  end

  def destroy
    @cart = ActiveSupport::JSON.decode((@current_user ? @current_user.reload.cart_data : session[:cart_data]) || '[]') rescue []
    @cart.reject!{|item|item["product_id"]==params[:id].to_s}
    if @current_user
      @current_user.update_attributes(:cart_data => @cart.to_json)
    else
      session[:cart_data] = @cart.to_json
    end

    respond_to do |format|
      format.html { redirect_to params[:redirect] || new_shop_trade_path }
      format.js { render :text => "" }
      format.xml { @data = {} }
    end
  end

  def authorized?
    super
    @enable_lazyload = true
    return true if %w[index show create destroy].include?(params[:action])
    @current_user = Shop::User.acquire(@current_user.id) if @current_user
    !!@current_user
  end
end
