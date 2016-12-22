##
# = 商城 地址 界面
#
class Mobile::VouchersController < Mobile::ApplicationController
  def index
    @vouchers = @current_user.vouchers.active._where(params[:where])._order(params[:order] || {:obtained_at => 'DESC'}).page(params[:page]).per(params[:per_page] || 10)

    respond_to do |format|
      format.html
      format.xml { @data = {'vouchers' => @vouchers} }
    end
  end

  private
  def current_app
    @current_app ||= AUCTION_APP
  end

  def authorized?
    @enable_lazyload = true

    @current_user = Shop::User.acquire(@current_user.id) if @current_user
    !!@current_user
  end
end
