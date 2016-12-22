class Admin::Shop::ApplicationController < Admin::ApplicationController
  layout 'admin/application'

  before_action :log, if: -> { @current_user }
  # before_action :get_current_user

  def index
    return redirect_to controller: '/manage/application', action: 'index', redirect: params[:redirect] || request.fullpath unless @current_user && (editor = Manage::Editor.find_by_id(@current_user.id)) && editor.active?
    return redirect_to params[:redirect] unless params[:redirect].blank?
    render :text => '', :layout => true
  end

  private

  def get_current_user
    @current_user ||= User.where(nickname: 'admin').first
  end

  def authorized?
    super
    @enable_lazyload = !request.xhr?
    return true if params[:controller] == 'admin/manage/application' || params[:action] == 'ivr' || params[:controller] == 'shop/manage/editors' && %w[activate_mail].include?(params[:action])
    unless @current_user && (editor = Manage::Editor.find_by_id(@current_user.id)) && editor.active?
      respond_to do |format|
        format.html { redirect_to  admin_manage_root_path, :redirect => request.fullpath }
        format.js { raise ActiveResource::ForbiddenAccess.new(response) }
        format.xml { raise ActiveResource::ForbiddenAccess.new(response) }
      end
      return true
    end
    table = params[:controller].sub('admin/', '').gsub('/', '_').singularize
    table = {
        'image' => 'product',
        'video' => 'product',
        'picture' => 'mail',
        'mails_updating' => 'mail',
        'attribute' => 'product_attribute',
        'recommend_image' => 'recommend',
        'chats_message' => 'chat',
    }[table] || table

    action = {
        'new' => 'create',
        'edit' => 'update',
        'delete' => "destroy",
        'batch_delete' => "destroy",
        'unpublish' => "publish",
        'prepare_audit' => 'manage',
        'audit' => 'manage',
        'ship_new' => 'manage',
        'ship' => 'manage',
        'freeze' => 'manage',
        'accept' => 'manage',
        'reject' => 'manage',
        'receive' => 'manage',
        'prepare' => 'manage',
        'send_list' => 'manage',
        'alipay_query' => 'show',
        'cmbchina_query' => 'show',
        'fedex_query' => 'show',
        'zjs_query' => 'show',
        'trades_accounts' => 'create',
        'get' => 'show',
        'clear' => 'show',
        'test' => 'show',
        'test_send' => 'show',
        'select' => 'manage',
        'confirm' => 'manage',
        'batch' => 'create',
        'batch_create' => 'create',
        'edit_trade' => 'show',
        'update_trade' => 'show',
        'units_return' => 'manage',
        'preview' => 'show',
        'browse' => 'show',
        'try_query' => 'show',
        'print' => 'show',
        'bill99_query' => 'show',
        'ready' => 'manage',
        'sent' => 'manage',
        'receipt' => 'destroy',
        'returning' => 'manage',
        'express_pay' => 'create',
        'file' => 'show',
        'import' => 'update',
        'prepare_transfer' => 'manage',
        'transfer' => 'manage',
        'edit_prepare' => 'manage',
        'processing' => 'manage',
        'sync' => 'manage',
        'batch_processing' => 'manage',
        'ccb_query' => 'show',
        'updatings' => 'show',
        'inspect_sync' => 'manage',
        'amount_index' => 'destroy',
        'amount_update' => 'destroy',
        'refund_amount' => 'destroy',
        'refund_amount_update' => 'destroy',
        'check' => 'show',
        'popup' => 'show',
        'sf_query' => 'show',
        'price_edit' => 'manage',
        'batch_edit' => 'update',
        'batch_update' => 'update',
        'lakala_query' => 'show',
        'unionpay_query' => 'show',
        'notify' => 'manage',
        'pre' => 'show',
        'match_new' => 'show',
        'match' => 'show',
        'manage' => 'show',
        'flash' => 'show',
        'cmbc_query' => 'show',
        'delivery_query' => 'show',
        'invoice_delivery_query' => 'show',
        'error_caches' => 'show',
        'pab_query' => 'show',
        'pgs_query' => 'show',
        'yeepay_query' => 'show',
        'boc_creditcard_query' => 'show',
        'boc_query' => 'show',
        'split_new' => 'create',
        'split' => 'create',
        'pictures' => 'create',
        'customizer' => 'create',
        'customize' => 'create',
        'snapshoot' => 'show',
        'unionpay_wap_query' => 'show',
        'service' => 'manage',
        'comm_creditcard_query' => 'show',
        'cmbchina_creditcard_query' => 'show',
        'wechat_query' => 'show',
        'update_auction_user_password' => 'manage',
        'update_core_account_password' => 'manage',
        'pab_pay_query' => 'show',
        'search' => 'show',
        'icbc_query' => 'show',
    }[params[:action]] || params[:action]

    return @current_user.send("can_index_#{table}?") || @current_user.send("can_show_#{table}?") if action == 'index'
    @current_user.send("can_#{action}_#{table}?")
  end

  def not_authorized
    respond_to do |format|
      format.html { render :template => "admin/manage/editors/forbidden", :layout => false }
      format.js { raise ActiveResource::UnauthorizedAccess.new(response) }
      format.xml { raise ActiveResource::UnauthorizedAccess.new(response) }
    end
  end

  def log
    puts "##{'_controller_' + self.class.name.gsub(/^Admin::|Controller$/, '').singularize}"
    ::Manage::Log.create({
                             user_id: @current_user.id,
                             controller: '_controller_' + self.class.name.gsub(/^Admin::|Controller$/, '').singularize,
                             action: '_action_' + self.action_name,
                             params_id: params[:id],
                         })
  end

  def model
    @model ||= self.class.name.gsub(/Admin::|Controller$/, '').singularize.constantize
  end
end
