class Admin::Shop::UnitsController < Admin::Shop::ApplicationController

  def index
    @units = ::Shop::Unit.where("status IS NOT NULL")._where(params[:where])._order(params[:order]).page(params[:page]).per(params[:per_page])
    # @units = [].paginate(:page => 1) unless @current_user.can?(:index, ::Shop::Unit.new) || @units.total_entries <= 1

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { render :xml => @units }
      format.csv { response.headers['Content-Disposition'] = 'attachment; filename=units.csv'; render :text => generate_csv(generate_tabulation(::Shop::Unit::FIELDS.find{ |f| f[:name] == params[:table] }[:value], @units)), :layout => false }
      format.tsv { response.headers['Content-Disposition'] = 'attachment; filename=units.tsv'; render :text => generate_tsv(generate_tabulation(::Shop::Unit::FIELDS.find{ |f| f[:name] == params[:table] }[:value], @units)), :layout => false }
      format.table { render :text => generate_table(generate_tabulation(::Shop::Unit::FIELDS.find{ |f| f[:name] == params[:table] }[:value], @units)), :layout => false }
    end
  end

  def show
    @unit = ::Shop::Unit.find(params[:id])

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { render :xml => @unit }
    end
  end

  def edit
    @unit = ::Shop::Unit.find(params[:id])

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { render :xml => @unit }
    end
  end

  def update
    @unit = ::Shop::Unit.find(params[:id])

    respond_to do |format|
      if @unit.update_attributes(unit_params)
        flash[:notice] = 'Editor was successfully updated.'
        format.html { redirect_to admin_shop_unit_path }
        format.js { head :ok }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.js { raise }
        format.xml { render :xml => @unit.errors, :status => :unprocessable_entity }
      end
    end
  end

  def returning
    @unit = ::Shop::Unit.acquire(params[:id])

    unless @unit.status.blank? && %w[audit prepare ship complete].include?(@unit.trade.status) && (@unit.trade.payment_service != 'express' || @unit.trade.status == 'complete')
      not_authorized
      return
    end

    database_transaction do
      @unit.request_editor_id = @current_user.id
      @unit.status = 'audit' if @unit.status.blank?
      @unit.request_at ||= Time.now
      @unit.save!
    end

    respond_to do |format|
      format.html { redirect_to admin_shop_units_path('where[id]' => @unit.id),status: :ok }
      format.xml { render :xml => @unit }
    end
  end

  def prepare_audit
    @unit = ::Shop::Unit.find(params[:id])

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { render :xml => @unit }
    end
  end

  def audit
    @unit = ::Shop::Unit.find(params[:id])

    unless @unit.status == "audit" && %w[audit prepare ship receive complete].include?(@unit.trade.status)
      not_authorized
      return
    end

    @success = database_transaction do
      @unit.update_attributes!(:audit_editor_id => @current_user.id, :audit_at => Time.now, :status => 'receive')
    end

    if @success
      Shop::Sms.create!(:user_id => @unit.trade.user.id, :trade_id => @unit.trade.id, :phone => @unit.return_phone,
                        :content => "已收到您的退货申请，请把货品寄回。如遇疑问请您致电客服电话查询反馈").send_by!(:service, @current_user) if @unit.return_phone? && params[:sms] && params[:sms][:success]
      respond_to do |format|
        format.html { redirect_to admin_shop_units_path,status: :ok }
        format.xml { render :xml => @unit }
      end
    else
      respond_to do |format|
        format.html { redirect_to  admin_shop_units_path,status: :ok }
        format.xml { render :xml => @unit }
      end
    end
  end

  def receive
    @unit = ::Shop::Unit.find(params[:id])

    unless @unit.status == "receive" && %w[audit prepare ship receive complete].include?(@unit.trade.status)
      not_authorized
      return
    end

    database_transaction do
      @unit.returnit!(:receive_editor_id => @current_user.id, :receive_at => Time.now, :status => 'transfer')
    end

    respond_to do |format|
      format.html { redirect_to  admin_shop_units_path,status: :ok }
      format.xml { render :xml => @unit }
    end
  end

  def prepare_transfer
    @unit = ::Shop::Unit.find(params[:id])

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { render :xml => @unit }
    end
  end

  def transfer
    @unit = ::Shop::Unit.find(params[:id])

    unless @unit.status == "transfer" && %w[audit prepare ship receive complete].include?(@unit.trade.status)
      not_authorized
      return
    end

    @success = database_transaction do
      @unit.update_attributes!(:transfer_editor_id => @current_user.id, :transfer_at => Time.now, :status => 'complete')
    end

    if @success
      Shop::Sms.create!(:user_id => @unit.trade.user.id, :trade_id => @unit.trade.id, :phone => @unit.return_phone,
                        :content => "您的退款已由账户汇出，到账时间根据银行系统接转周期约1-7个工作日，可致电银行查询到账时间。如遇疑问请您致电客服电话查询反馈",
                        :editor_id => @current_user.id).send_by!(:service, @current_user) if @unit.return_phone? && params[:sms] && params[:sms][:success]

      respond_to do |format|
        format.html { redirect_to admin_shop_units_path ,status: :ok}
        format.xml { render :xml => @unit }
      end
    else
      respond_to do |format|
        format.html { redirect_to admin_shop_units_path,status: :ok }
        format.xml { render :xml => @unit }
      end
    end
  end

  def freeze
    @unit = ::Shop::Unit.find(params[:id])

    unless @unit.status == "audit" && %w[audit prepare ship receive complete].include?(@unit.trade.status)
      not_authorized
      return
    end

    database_transaction do
      @unit.update_attributes!(:status => 'freezed', :freeze_editor_id => @current_user.id, :freeze_at => Time.now)
    end

    respond_to do |format|
      format.html { redirect_to request.referer || admin_shop_units_path,status: :ok }
      format.xml { render :xml => @unit }
    end
  end

  def print
    @unit = ::Shop::Unit.acquire(params[:id])

    respond_to do |format|
      format.html { render :layout => false }
      format.xml { render :text => @unit }
    end
  end

  protected
  def unit_params
    params[:unit].permit ["return_reason", "remark", "receipt_number"]
  end
end
