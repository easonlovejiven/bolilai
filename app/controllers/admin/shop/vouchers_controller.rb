##
# = 商城 管理 代金券 界面
#
class Admin::Shop::VouchersController < Admin::Shop::ApplicationController
  def index
    @vouchers = ::Shop::Voucher.active._where(params[:where])._order(params[:order]).page(params[:page]).per(params[:per_page])
    @vouchers = @vouchers.avalable.assign_options(include: {event: {except: []}}) if params[:avalable]
    # @vouchers = [].paginate(:page => 1) unless @current_user.can?(:index, ::Shop::Voucher.new) || @vouchers.total_entries <= 1

    respond_to do |format|
      format.html { render "index", layout: false if request.xhr? }
      format.xml { @data = @vouchers.assign_options(include: {event: {except: []}}) }
      format.js { render :text => @vouchers.to_json }
      format.csv { response.headers['Content-Disposition'] = 'attachment; filename=vouchers.csv'; render :layout => false }
    end
  end

  def show
    @voucher = ::Shop::Voucher.acquire(params[:id])
    respond_to do |format|
      format.html { render :action => 'show', layout: false if request.xhr? }
    end
  end

  def new
    voucher_params=params.permit(:shop_voucher)
    @voucher = ::Shop::Voucher.new
    voucher_params[:shop_voucher] = (voucher_params||{}).merge(@voucher.class.acquire(params[:id]).attributes) if params[:id]
    @voucher.attributes = (voucher_params[:shop_voucher]||{}).slice(*@voucher.class.manage_fields)

    respond_to do |format|
      format.html { render :action => 'show', layout: false if request.xhr? }
    end
  end


  ##
  # == 后台创建代金券
  #
  # === Request
  #
  # ==== Resource
  #
  # POST /shop/manage/vouchers
  #
  # ==== Parameters
  #
  # \voucher[event_id] :: 事件ID
  # \voucher[remark] :: 备注
  # \voucher[user_id] :: 用户ID（默认为匿名）
  # quantity :: 数量（默认为1）
  #
  # === Response
  #
  # ==== JSON
  #
  #   {
  #     "vouchers" : [
  #       {
  #         "id" : ID,
  #         "user_id" : 用户ID,
  #         "event_id" : 券种ID,
  #         "trade_id" : 订单ID,
  #         "identifier" : 编号,
  #         "obtained_at" : 获得时间,
  #         "event" : {
  #           "id" : 券种ID,
  #           "name" : 名称,
  #           "amount" : 金额,
  #           "limitation" : 限制,
  #           "description" : 描述,
  #           "started_at" : 开始时间,
  #           "ended_at" : 结束时间,
  #         },
  #       },
  #     ]
  #   }
  #
  def create
    @event = Shop::Event.acquire(params[:event_id] || params[:voucher][:event_id])

    if @event.ended_at < Time.now
      not_authorized
      return
    end

    @success = database_transaction do
      raise if !params[:quantity].nil? && params[:quantity].to_i < 1
      @vouchers = (params[:quantity] || 1).to_i.times.map do
        # (params[:user_ids] && (uids = params[:user_ids].split(/[\r\n]+/).map { |l| (m = l.match(/(\d+)(.*)/)) ? {:user_id => m[1].to_i, :remark => m[2]} : nil }.compact) && !uids.blank? && uids || [{:user_id => params[:voucher][:user_id].blank? ? nil : params[:voucher][:user_id].to_i}]).map do |options|
        (params[:user_ids] && (uids = params[:user_ids].split(/[\r\n]+/).compact.map { |m| {:user_id => m.to_i} }) && !uids.blank? && uids || [{:user_id => params[:voucher][:user_id].blank? ? nil : params[:voucher][:user_id].to_i}]).map do |options|
          options[:user_id] = Core::User.acquire(options[:user_id]).id if options[:user_id]
          @event.vouchers.create!(
            :identifier => options[:user_id] ? nil : 12.times.map { Shop::Card::CHARACTERS.shuffle.first }.join,
            :user_id => options[:user_id],
            :editor_id => @current_user.id,
            :remark => "#{params[:voucher][:remark]}#{options[:remark]}",
            :obtained_at => options[:user_id] ? Time.now : nil
          ) #rescue redo
        end
      end.flatten!
    end

    respond_to do |format|
      if @success
        format.html
        format.xml { @data = {'vouchers' => @vouchers} }
      else
        format.html
        format.xml { raise ArgumentError }
      end
    end
  end

  def edit
    @voucher = ::Shop::Voucher.acquire(params[:id])

    respond_to do |format|
      format.html { render :action => 'show', layout: false if request.xhr? }
    end
  end

  def update
    voucher_params=params.permit [:voucher]
    @voucher = ::Shop::Voucher.acquire(params[:id])
    raise unless @voucher.editor_id == @current_user.id
    @voucher.attributes = (voucher_params[:voucher]||{}).slice(*@voucher.class.manage_fields).merge(:editor_id => @current_user.id)
    @voucher.save

    respond_to do |format|
      format.html { render :action => 'show' }
      format.js { head @voucher.valid? ? :accepted : :bad_request }
    end
  end

  def delete
    @voucher = ::Shop::Voucher.acquire(params[:id])

    respond_to do |format|
      format.html { render template: 'admin/shared/delete', locals: {record: @voucher, unable_msg: '此记录无法删除？'}, :layout => false }
      format.xml { render :xml => @voucher }
    end
  end

  def batch_delete
    @vouchers = ::Shop::Voucher.where(id: params[:ids].split(","))
    respond_to do |format|
      format.html { render template: 'admin/shared/batch_delete', locals: {records: @vouchers, del_url: admin_shop_vouchers_path(:id => @vouchers.map(&:id).join(",")), unable_msg: '该页面无法删除？'}, :layout => false }
      format.xml { render :xml => @vouchers }
    end
  end

  def destroy
    @vouchers = ::Shop::Voucher.where(id: params[:id].split(","))
    @vouchers.update_all({:active => false})

    respond_to do |format|
      format.html { redirect_to :action => 'index', status: :ok }
    end
  end

  def import
    csv = CSV.parse(params[:csvs].map { |csv| csv.respond_to?(:read) ? csv.read : csv }.join("\n").gsub(/[\r\n]+/, "\n").strip).reject { |c| c[0].blank? }

    @success = database_transaction do
      csv.each do |event_id, name, limitation, amount, user_id, remark, quantity|
        raise unless (event = Shop::Event.acquire(event_id.toutf8)) && !(event.ended_at < Time.now) && event.name == name.strip && event.limitation == limitation.to_i && event.amount == amount.to_i && user = Core::User.acquire(user_id)
        (quantity || 1).to_i.times.map do
          event.vouchers.create!(
            :identifier => user ? nil : 12.times.map { Shop::Card::CHARACTERS.shuffle.first }.join,
            :user_id => user.id,
            :editor_id => @current_user.id,
            :remark => remark,
            :obtained_at => Time.now
          ) rescue redo
        end
      end
    end
  end
end
