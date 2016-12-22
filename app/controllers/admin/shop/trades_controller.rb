class Admin::Shop::TradesController < Admin::Shop::ApplicationController
  before_filter :shop_authorized, except: [:index, :create, :inspect_sync, :amount_index, :amount_update, :refund_amount, :refund_amount_update, :amount_update]

  def index
    @trades = ::Shop::Trade
    # @trades = @trades.where(shop_id: @current_user.guide.shop.id) if @current_user.guide.try(:shop).try(:id)

    if params[:query_field].present? && params[:query_content].present?
      query_content = case params[:query_field]
                        when 'id'
                          params[:query_content].scan(/\d+/).uniq
                        when 'identifier'
                          params[:query_content].scan(/\d{14}\w{6}/).uniq
                        else
                          params[:query_content].scan(/[a-zA-Z]{2}\d+[a-zA-Z]{2}[a-zA-Z].|\d{12}|\d{10}/)
                      end
      content = query_content.blank? ? 'null' : query_content.map { |s| "'#{s}'" }.join(', ')
      # @trades = @trades.scoped(:conditions => "#{params[:query_field]} IN (#{content})", :order => params[:order] ? params[:order].map { |k, v| "#{k} #{v.upcase == 'ASC' ? 'ASC' : 'DESC'}" } : "FIELD(#{params[:query_field]}, #{content})") and params[:per_page] = 99999
    end

    if params[:shop_trades]
      gt = Time.parse(params[:shop_trades][:created_at][:gteq]) rescue Time.now
      lt = Time.parse(params[:shop_trades][:created_at][:lteq]) rescue Time.now
      @trades = @trades.scoped(:conditions => "1 > 2") if lt - gt > 1.month
      @trades = @trades.scoped(:conditions => ["shop_trades.created_at >= ? AND shop_trades.created_at <= ?", gt, lt], :select => "DISTINCT shop_trades.id, shop_trades.*", :limit => 10).scoped(:conditions => !params[:shop_trades][:user_id].blank? && ["shop_trades.user_id = ?", params[:shop_trades][:user_id]]).scoped(:conditions => !params[:shop_trades][:delivery_phone].blank? && ["shop_trades.delivery_phone = ?", params[:shop_trades][:delivery_phone]])
      @trades = @trades.scoped(:joins => "JOIN auction_contacts ON auction_contacts.id = shop_trades.contact_id").scoped(:conditions => !params[:auction_contacts][:name].blank? && ["auction_contacts.name LIKE ?", "%#{params[:auction_contacts][:name]}%"]).scoped(:conditions => !params[:auction_contacts][:mobile].blank? && ["auction_contacts.mobile = ?", params[:auction_contacts][:mobile]]) if !params[:auction_contacts].values.reject(&:blank?).blank?
      @trades = @trades.scoped(:joins => "JOIN auction_units ON auction_units.trade_id = shop_trades.id JOIN auction_items ON auction_items.id = auction_units.item_id JOIN shop_products ON shop_products.id = auction_items.product_id").scoped(:conditions => !params[:shop_products][:name].blank? && ["shop_products.name LIKE ?", "%#{params[:shop_products][:name]}%"]).scoped(:conditions => !params[:shop_products][:brand_id].blank? && ["shop_products.brand_id = ?", params[:shop_products][:brand_id]]).scoped(:conditions => !params[:shop_products][:category1_id].blank? && ["shop_products.category1_id = ?", params[:shop_products][:category1_id]]).scoped(:conditions => !params[:shop_products][:category2_id].blank? && ["shop_products.category2_id = ?", params[:shop_products][:category2_id]]) if !params[:shop_products].values.reject(&:blank?).blank?
    end

    @trades = @trades.active._where(params[:where])._order(params[:order])
    # @trades = @trades.where(["created_at > ?", 14.days.ago])
    #unless @current_user.can_publish_trade? || params[:shop_trades] || (@current_user.can?(:show, ::Shop::Trade.new) && @trades.count <= 1)
    # @trades = @trades.map if params[:shop_trades]
    @trades = @trades.page(params[:page]).per(params[:per_page])
    # @trades = [].paginate(:page => 1) unless @current_user.can?(:index, ::Shop::Trade.new) || @trades.total_entries <= 1
    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { render :xml => @trades }
      format.csv { response.headers['Content-Disposition'] = 'attachment; filename=trades.csv'; render :layout => false }
    end
  end

  def new
    @trade = model.new
    params[:shop_trade] = model.f(params[:id]).attributes.merge(params[:shop_trade].to_h).merge(original_id: params[:id].to_i) if params[:id]
    @trade.attributes = params[:shop_trade].to_h.slice(*model.create_fields)
    # @trade.shop = @current_user.guide.try(:shop)
    # @trade.guide = @current_user.guide if @trade.shop
    # @trade.need_delivery = !!@trade.contact
    # @trade.need_invoice = !!@trade.invoice_contact
    @trade.valid? if params.has_key?(:valid)
    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
    end
  end

  def create
    @trade = ::Shop::Trade.new
    # @trade.shop = @current_user.guide.try(:shop)
    # @trade.guide = @current_user.guide if @trade.shop

    @success = database_transaction do
      @trade.save(validate: false)

      user_id = params[:shop_trade].try(:[], 'user_id').to_i
      @user = Shop::User.f(user_id)
      @editor = @current_user

      @original = ::Shop::Trade.find(params[:id]) if params[:id]
      @original.freeze!(freeze_editor_id: @current_user.id) if @original.try(:freezable?)

      units = params[:shop_trade][:units]
      units = units.values if units.is_a?(Hash)
      raise 'invalid units' if units.blank?

      @trade.units = units.map do |unit|
        unit = unit.with_indifferent_access

        item = Shop::Item.find_by(id: unit[:item_id])
        raise 'invalid item' if item.try(:trade_id)

        product = item.try(:product) || Shop::Product.find_by(id: unit[:product_id])
        raise 'invalid product' unless product.try(:published?)
        raise 'invalid mall' unless !@user || [@user.malls, @user.level.try(:malls).to_a].flatten.include?(product.mall)

        item ||= product.items.published.unsold
                     .where(unit[:measure].present? && unit.slice(:measure))
                     .order(Shop::Category::PRIORITIES.map { |p| {p[:name] => p[:order]} }.inject({}, &:merge)[product.category2.try(:priority)] || Shop::Category::PRIORITIES.first[:order])
                     .first
        raise 'invalid item' unless item

        if @user

          # unit[:percent]

          multibuy = Shop::Multibuy.find_by(id: unit[:multibuy_id].to_i) if unit[:multibuy_id].present?
          raise 'invalid multibuy' unless !multibuy || multibuy.published? && product.multibuy_id == multibuy.id && (percent = multibuy.percent_for(units.count { |unit| unit[:multibuy_id].to_i == multibuy.id })) > 0

          point_percent = unit[:point_percent].to_i
          point = point_percent == 100 ? product.point.to_i : point_percent * 1000
          raise 'invalid point_percent' unless product.mall.percent.to_i >= point_percent && (@user.percent.to_i >= point_percent || [0, 5, 10].include?(point_percent) || point_percent == 100 && product.point.to_i > 0)

          level_percent = unit[:level_percent].to_i
          raise 'invalid level_percent' unless @user.level.percent >= level_percent

          voucher = Shop::Voucher.f(unit[:voucher_id]) if unit[:voucher_id].present?
          raise 'invalid voucher' unless !voucher || voucher.user_id == @user.id && !voucher.trade_id && voucher.event.started_at <= Time.now && Time.now <= voucher.event.ended_at && product.discount >= voucher.event.limitation

          guide_percent = unit[:guide_percent].to_i
          raise 'invalid guide_percent' unless [product.mall.percent.to_i, @editor.guide.try(:percent).to_i].all? { |percent| percent >= guide_percent }
        end

        percent = [percent, point_percent, level_percent, guide_percent].map(&:to_i).find(&:nonzero?)
        raise 'multiple promotions' if ([!!params[:shop_user].try(:[], :password), !!voucher, !!multibuy, point_percent.to_i > 0, guide_percent.to_i > 0, level_percent.to_i > 0] - [false]).size > 1

        discount = @user ? product.discount : product.shop_price
        price = discount * (100 - percent.to_i) / 100
        price = discount - voucher.event.amount if voucher
        price = 0 if price < 0
        raise 'less than minimum_price' unless price >= product.minimum_price.to_i

        item.update_attributes!(trade_id: @trade.id)
        voucher.update_attributes!(trade_id: @trade.id) if voucher

        unit = Shop::Unit.new
        unit.attributes = {
            trade_id: @trade.id,
            user_id: @user.try(:id),
            item_id: item.id,
            percent: percent,
            point_percent: point_percent,
            level_percent: level_percent,
            # guide_percent: guide_percent,
            discount: product.discount,
            point: point,
            voucher_id: voucher.try(:id),
            multibuy_id: multibuy.try(:id),
            price: price,
        }
        product.sync_sell_data!
        unit
      end

      if attrs = params[:shop_trade][:contact_attributes]
        contact = attrs[:id].present? && Shop::Contact.find_by(id: attrs[:id])
        contact = nil if contact && !contact.class.manage_fields.map { |field| contact[field] == attrs[field] }.inject(&:&)
        contact ||= Shop::Contact.create!(attrs.merge(user_id: @user.try(:id), editor_id: @editor.id))
      end

      if attrs = params[:shop_trade][:invoice_contact_attributes]
        invoice_contact = attrs[:id].present? && Shop::Contact.find_by(id: attrs[:id])
        invoice_contact = nil if invoice_contact && !invoice_contact.class.manage_fields.map { |field| invoice_contact[field] == attrs[field] }.inject(&:&)
        invoice_contact ||= contact if contact && contact.class.manage_fields.map { |field| contact.attributes[field] == invoice_contact.attributes[field] }.inject(&:&)
        invoice_contact ||= Shop::Contact.create!(attrs.merge(user_id: @user.try(:id), editor_id: @editor.id))
      end

      # deduct point if need
      if (point = @trade.units.map(&:point).map(&:to_i).inject(&:+).to_i) && point > 0
        info = Core::Info.acquire(@user.id)
        raise 'invalid point' if point > info.point
        info.user.do_transaction!(-point, "购买时使用基因值抵折扣，交易ID=#{@trade.id}")
      end

      # update trade information
      defaults = {
          editor_id: @editor.id,
          user_id: @user.try(:id),
          contact_id: contact.try(:id),
          invoice_contact_id: invoice_contact.try(:id),
          price: @trade.units.map(&:price).inject(&:+).to_i,
          payment_price: @trade.units.map(&:price).inject(&:+).to_i,
          status: 'pay',
          identifier: '%04d%02d%02d%02d%04d%06s' % [Time.now.year, Time.now.month, Time.now.day, rand(100), rand(10000), ((0..9).to_a*3+('A'..'Z').to_a).shuffle[0..5].join],
          checkout_token: SecureRandom.hex(16),
          client: 'manage',
          # guide_id: @editor.guide.try(:id),
          # shop_id: @editor.guide.try(:shop).try(:id),
      }
      @trade.attributes = defaults.merge(params[:shop_trade].slice(*model.create_fields))
      @trade.save!
      @trade.updated!(:status => @trade.status)

      # give away with skipping payment if price is zero
      if @trade.payment_price == 0
        @trade.update_attributes!(status: 'audit', payment_service: 'giveaway')
        @trade.updated!(:status => @trade.status)
      end

      if @trade.shop
        @trade.update_attributes!(status: 'audit', payment_service: 'shop')
      end
    end

    if @success
      respond_to do |format|
        format.html { render action: 'show' }
        format.xml { @data = {trade: @trade.assign_options(only: [:id])} }
      end
    else
      respond_to do |format|
        format.html { render action: 'new' }
        format.xml { raise }
      end
    end
  end

  def show
    @trade = ::Shop::Trade.find(params[:id])
    # return not_authorized if !@current_user.can_publish_trade? && @trade.created_at < 14.days.ago

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { render :xml => @trade }
    end
  end

  def edit
    @trade = ::Shop::Trade.find(params[:id])
    # return not_authorized if !@current_user.can_publish_trade? && @trade.created_at < 14.days.ago

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { render :xml => @trade }
    end
  end

  def update
    @trade = ::Shop::Trade.find(params[:id])
    # return not_authorized if @trade.created_at < 14.days.ago

    respond_to do |format|
      if @trade.update_attributes(params.require(:trade).permit!.slice(*%w[delivery_service delivery_identifier remark invoice_delivery_identifier invoice_delivery_service package_from package_to package_content whisper_style whisper_from whisper_to whisper_content shop_id shop_identifier guide_id remark]).merge((m = params[:trade][:invoice_remark]) && !m.blank? ? {:invoice_remark => "#{ @trade.invoice_remark.blank? ? "" : "#{@trade.invoice_remark}\n\n" }#{m} [#{Time.now.to_s(:db)}]"} : {}))
        flash[:notice] = 'Trade was successfully updated.'
        format.html { redirect_to admin_shop_trade_path(@trade) }
        format.js { head :ok }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.js { raise }
        format.xml { render :xml => @trade.errors, :status => :unprocessable_entity }
      end
    end
  end

  def audit
    @trade = ::Shop::Trade.find(params[:id])

    if @trade.status != 'audit'
      not_authorized
      return
    end

    @success = database_transaction do
      @trade.update_attributes!(:status => 'prepare', :audit_editor_id => @current_user.id, :audit_at => Time.now)
      # @trade.updated!(:status => @trade.status)
    end

    respond_to do |format|
      if @success
        # (HTTParty.post("http://#{OAUTH_CONFIG['erp']['site']}/tools/import.trades", :query => {:identifier => @trade.identifier, :username => OAUTH_CONFIG['erp']['username'], :password => OAUTH_CONFIG['erp']['password']}) if @trade.status == 'prepare') rescue nil
        # format.html { redirect_to request.referer || admin_shop_trade_path(@trade) }
        format.html { redirect_to admin_shop_trade_path(@trade), status: :ok }
        format.xml
      else
        format.html { redirect_to admin_shop_trade_path(@trade) }
        # format.html { redirect_to request.referer || admin_shop_trade_path(@trade) }
        format.xml { head 500 }
      end
    end
  end

  def edit_prepare
    @trade = ::Shop::Trade.find(params[:id])

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { render :xml => @trade }
    end
  end

  def prepare
    @trade = ::Shop::Trade.find(params[:id])

    if @trade.status != 'prepare'
      not_authorized
      return
    end

    @success = database_transaction do
      (params[:units]||[]).each do |p|
        unit = Shop::Unit.find(p[:id])
        unit.update_attributes! :prepared => !!p[:prepared], :prepare_remark => p[:prepare_remark]
      end

      if @trade.contact.nil?
        @trade.units.each { |p| p.update_attributes! :prepared => true }
      end

      if @trade.units.reject { |u| u.status == 'complete' || u.status == 'transfer' }.map(&:prepared).inject(true, &:&)
        @trade.update_attributes!(:status => 'ship', :prepare_editor_id => @current_user.id, :prepare_at => Time.now)
        # @trade.updated!(:status => @trade.status)
        # @trade.sale_out! if  @trade.contact.nil?
      end
    end

    respond_to do |format|
      if @success
        format.html { redirect_to admin_shop_trade_path(@trade), status: :ok }
        format.xml
      else
        format.html { redirect_to admin_shop_trade_path(@trade) }
        format.xml { head 500 }
      end
    end
  end

  def ship_new
    @trade = ::Shop::Trade.find(params[:id])

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { render :xml => @trade }
    end
  end

  def ship
    @trade = ::Shop::Trade.find(params[:id])

    if @trade.status != 'ship'
      not_authorized
      return
    end

    @success = database_transaction do
      trade_ship_params = {:status => 'receive', :ship_editor_id => @current_user.id, :ship_at => Time.now}
      @trade.update!(trade_ship_params.merge(params[:trade].slice(:delivery_service, :delivery_identifier)))
      # @trade.updated!(:status => @trade.status)
    end

    respond_to do |format|
      if @success
        if @trade.user
          Core::Mailer.mail(
              :recipients => @account.email,
              :subject => "您的订单#{@trade.identifier}已发货",
              :template => 'shop_ship',
              :body => {:trade => @trade}
          ) if (@account = Core::Account.find(@trade.user)) && @account.user.setting.receive_promotion_email?
          Shop::Sms.create!(:user_id => @trade.user.id, :trade_id => @trade.id, :phone => @trade.delivery_phone,
                            :content => "您的订单已经#{"#{@trade.delivery_service? && !%w[pickup offline].include?(@trade.delivery_service) ? "通过"<<Shop::Trade.delivery_coms_arr.find { |s| s[:name]==@trade.delivery_service }[:title] : ""}"}发货#{@trade.delivery_identifier? ? "，运单号#{@trade.delivery_identifier}，请您注意查收" : ""}",
                            :editor_id => @current_user.id).send_by!(:shop_buy, @current_user) if @trade.delivery_phone? && params[:sms] && params[:sms][:success] == '1'
          @trade.send_alipay_shipped if @trade.payment_service.to_s.match(/^alipay_?/)
          @trade.send_wechat_shipped if @trade.payment_service == 'wechat'
          # @trade.send_shipped
        end
        flash[:notice] = 'Trade was successfully updated.'
        format.html { redirect_to admin_shop_trades_path, status: :ok }
        format.xml
      else
        format.html { render :action => "edit" }
        format.xml { head 500 }
      end
    end
  end

  def freeze
    @trade = ::Shop::Trade.find(params[:id])

    unless @trade.freezable?
      not_authorized
      return
    end

    @success = database_transaction do
      @current_status = @trade.status
      @trade.update_attributes!(:status => 'freezed', :freeze_editor_id => @current_user.id, :freeze_at => Time.now)
      # @trade.updated!(:status => @trade.status)
      # @trade.ticket.update_attributes!(:trade_id => nil, :user_id => nil) if @trade.ticket
      @trade.units.each(&:returnit!)
      # @trade.calculate_product_hourglass!
      @trade.close_payment
    end

    respond_to do |format|
      if @success
        # HTTParty.post("http://#{OAUTH_CONFIG['erp']['site']}/tools/trade.freeze", :query => {:status => 1, :tradeID => @trade.id, :identifier => @trade.identifier, :username => OAUTH_CONFIG['erp']['username'], :password => OAUTH_CONFIG['erp']['password']}) if %w[ship receive complete].include?(@current_status)

        format.html { redirect_to admin_shop_trades_path, status: :ok }
        format.xml { head :ok }
      else
        format.html { redirect_to admin_shop_trade_path(@trade) }
        format.xml { render :xml => @trade.errors, :status => :unprocessable_entity }
      end
    end
  end

  def alipay_query
    @trade = ::Shop::Trade.acquire(params[:id])
    @xml = Nokogiri::XML(Mechanize.new.get(@trade.alipay_query_url).body)

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { render :text => @xml }
    end

  end

  def delivery_query
    @trade = ::Shop::Trade.find(params[:id])

    @details = @trade.trade_delivery_result

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { render :text => @details }
    end
  end

  def invoice_delivery_query
    @trade = ::Shop::Trade.find(params[:id])

    @details = @trade.invoice_delivery_result

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { render :text => @details }
    end
  end

  def cmbchina_query
    @trade = ::Shop::Trade.find(params[:id])

    @result = @trade.cmbchina_result

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { render :text => @result }
    end
  end

  def cmbchina_creditcard_query
    @trade = ::Shop::Trade.find(params[:id])
    @result = @trade.cmbchina_creditcard_result

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { render :text => @result }
    end
  end

  def bill99_query
    @trade = ::Shop::Trade.find(params[:id])

    @result = @trade.bill99_result

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { render :text => @result }
    end
  end

  def lakala_query
    @trade = ::Shop::Trade.find(params[:id])

    @result = @trade.lakala_result rescue {}

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { render :text => @result }
    end
  end

  def ccb_query
    @trade = ::Shop::Trade.find(params[:id])

    @result = @trade.ccb_query_data['DOCUMENT']['QUERYORDER'] rescue {}

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { render :text => @result }
    end
  end

  def unionpay_query
    @trade = ::Shop::Trade.find(params[:id])

    @result = @trade.unionpay_result rescue {}

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { render :text => @result }
    end
  end

  def unionpay_wap_query
    @trade = ::Shop::Trade.find(params[:id])

    @result = @trade.unionpay_wap_result rescue {}

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { render :text => @result }
    end
  end

  def cmbc_query
    @trade = ::Shop::Trade.find(params[:id])

    @result = @trade.cmbc_result

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { render :text => @result }
    end
  end

  def pab_query
    @trade = ::Shop::Trade.find(params[:id])
    @result = @trade.pab_result

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { render :text => @result }
    end
  end

  def pab_pay_query
    @trade = ::Shop::Trade.find(params[:id])
    @result = @trade.pab_pay_result

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { render :text => @result }
    end
  end

  def pgs_query
    @trade = ::Shop::Trade.acquire(params[:id])
    @result = @trade.pgs_result

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { render :text => @result }
    end
  end

  def yeepay_query
    @trade = ::Shop::Trade.acquire(params[:id])
    @result = @trade.yeepay_result

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { render :text => @result }
    end
  end

  def boc_creditcard_query
    @trade = ::Shop::Trade.acquire(params[:id])
    @result = @trade.boc_creditcard_result

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { render :text => @result }
    end
  end

  def boc_query
    @trade = ::Shop::Trade.acquire(params[:id])
    @result = @trade.boc_result

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { render :text => @result }
    end
  end

  def comm_creditcard_query
    @trade = ::Shop::Trade.acquire(params[:id])
    @result = @trade.comm_creditcard_result rescue nil

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { render :text => @result }
    end
  end

  def wechat_query
    @trade = ::Shop::Trade.acquire(params[:id])
    @result = @trade.wechat_result rescue {}

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { render :text => @result }
    end
  end

  def icbc_query
    @trade = ::Shop::Trade.acquire(params[:id])
    @result = Nokogiri::XML(@trade.icbc_result)

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { render :text => @result }
    end
  end

  def trades_accounts
    @accounts = Core::Account.where('id = :query OR email = :query OR phone = :query', params.slice(:query))

    respond_to do |format|
      format.xml { @data = {accounts: @accounts.assign_options(only: [:id, :email, :phone], include: {user: {only: [:name, :sex]}, shop_user: {only: [:id], include: {level: {only: [:id, :name, :percent, :icon]}}}})} }
    end
  end

  def try_query
    @trade = ::Shop::Trade.find(params[:id])

    database_transaction do
      @trade.try_query_payment!
    end

    respond_to do |format|
      format.html { redirect_to request.referer || admin_shop_trade_path(@trade) }
      format.xml { render :text => @trade }
    end
  end

  def print
    @trade = ::Shop::Trade.find(params[:id])

    # if  !%w[ship prepare].include?(@trade.status)
    # 	not_authorized
    # 	return
    # end

    # @user = Core::User.find(@trade.user_id)

    respond_to do |format|
      format.html { render :layout => false }
      format.xml { render :text => @trade }
    end
  end

  def receipt
    @trade = ::Shop::Trade.find(params[:id])

    unless !@trade.receipted_at? && %w[receive complete].include?(@trade.status)
      not_authorized
      return
    end

    @trade.update_attributes!(:receipt_editor_id => @current_user.id, :receipted_at => Time.now)

    respond_to do |format|
      format.html { redirect_to request.referer || admin_shop_trade_path(@trade), status: :ok }
      format.xml { render :text => @trade }
    end
  end

  def receive
    @trade = ::Shop::Trade.find(params[:id])

    if @trade.status != 'receive'
      not_authorized
      return
    end

    @success = database_transaction do
      @trade.update_attributes!(:status => 'complete')
      # @trade.updated!(:status => @trade.status)
    end

    respond_to do |format|
      if @success
        format.html { redirect_to admin_shop_trades_path, status: :ok }
        format.xml
      else
        format.html { admin_shop_trade_path(@trade) }
        format.xml { head 500 }
      end
    end
  end

  def express_pay
    @trade = ::Shop::Trade.find(params[:id])

    if @trade.status != 'pay'
      not_authorized
      return
    end

    @success = database_transaction do
      @trade.audit!(:payment_service => 'express')
    end

    respond_to do |format|
      if @success
        format.html { redirect_to admin_shop_trade_path(@trade), status: :ok }
        format.xml { head :ok }
      else
        format.html { redirect_to admin_shop_trade_path(@trade) }
        format.xml { render :xml => @trade.errors, :status => :unprocessable_entity }
      end
    end
  end

  def inspect_sync
    @trades = ::Shop::Trade.active.scoped(:conditions => ["shop_trades.status in ('prepare','ship','receive','complete') and shop_trades.prepare_at > ?", 14.days.ago])
    identifiers = @trades.empty? ? [] : @trades.map(&:identifier) - ErpRecord.connection.select_all("SELECT identifier FROM erp_exorders WHERE created_at > '#{(@trades.minimum(:created_at)-0.5.hours).to_s(:db)}'").map { |e| e['identifier'] }
    @trades = @trades.find_all { |t| identifiers.include? t.identifier }

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { render :xml => @trades }
    end
  end

  def sync
    @trade = ::Shop::Trade.find(params[:id])

    unless %w[prepare ship receive complete].include?(@trade.status)
      not_authorized
      return
    end

    status = HTTParty.post("http://#{OAUTH_CONFIG['erp']['site']}/tools/import.trades.status?", :query => {:identifier => @trade.identifier, :status => @trade.status, :username => OAUTH_CONFIG['erp']['username'], :password => OAUTH_CONFIG['erp']['password']})

    logger.info "erp trade sync import.trades.status #{@trade.status} #{status.body}"

    respond_to do |format|
      if status.body == '4'
        format.html { redirect_to inspect_sync_admin_shop_trades_path }
        format.js { head :ok }
        format.xml { head :xml => @trades }
      else
        format.html { redirect_to request.referer || admin_shop_trade_path(@trade) }
        format.js { raise }
        format.xml { head :xml => @trades }
      end
    end
  end


  def amount_index
    @trades = ::Shop::Trade
    @trades = @trades.where(shop_id: @current_user.guide.try(:shop).try(:id)) if @current_user.guide.try(:shop).try(:id)

    if !params[:query_field].blank? && !params[:query_content].blank?
      query_content = case params[:query_field]
                        when 'id'
                          params[:query_content].scan(/\d+/).uniq
                        when 'identifier'
                          params[:query_content].scan(/\d{14}\w{6}/).uniq
                        else
                          params[:query_content].scan(/[a-zA-Z]{2}\d+[a-zA-Z]{2}+|\d{12}|\d{10}/)
                      end
      @trades = @trades.scoped(:conditions => "#{params[:query_field]} IN (#{query_content.blank? ? 'null' : query_content.map { |s| "'#{s}'" }.join(', ') })") and params[:per_page] = 99999
    end

    # @trades = @trades.scoped(:conditions => ["created_at > ?", 14.days.ago]) unless @current_user.can_publish_trade?
    @trades = @trades.where(params[:where]).order(params[:order]).paginate(:page => params[:page], :per_page => params[:per_page] || 20)

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { render :xml => @trades }
    end
  end

  def amount_update
    @unit = Shop::Unit.find(params[:unit][:id])
    success = database_transaction do
      @unit.update_attributes!(params[:unit].slice(:amount_received, :amount_returned).merge({
                                                                                                 'amount_received' => {:amount_receive_editor_id => @current_user.id, :amount_received_at => Time.now},
                                                                                                 'amount_returned' => {:amount_return_editor_id => @current_user.id, :amount_returned_at => Time.now},
                                                                                             }.slice(*params[:unit].slice(:amount_received, :amount_returned).keys).values.inject(&:merge)
                               ))
    end
    if success
      respond_to do |format|
        format.html { render :layout => false if request.xhr? }
        format.js { render :text => "" }
        format.xml { render :xml => @trades }
      end
    else
      respond_to do |format|
        format.html { render :layout => false if request.xhr? }
        format.js { raise }
        format.xml { render :xml => @trades }
      end
    end
  end

  def refund_amount
    @unit = Shop::Unit.find(params[:id])

    respond_to do |format|
      format.html { render :layout => false if request.xhr? }
      format.xml { render :xml => @unit }
    end
  end

  def refund_amount_update
    @unit = Shop::Unit.find(params[:id])
    raise '退款金额不合法' if params[:shop_unit].values.sum.to_i < 0
    not_authorized and return unless ['transfer', 'complete'].include?(@unit.status) and %w[audit prepare ship receive complete].include?(@unit.trade.status)
    @success = database_transaction do
      if params[:shop_unit][:amount_balance_returned].to_i > 0
        raise '余额退款不可重复操作' unless @unit.amount_balance_returned.to_i == 0
        @unit.trade.user.update_attributes!(balance: @unit.trade.user.balance.to_i + params[:shop_unit][:amount_balance_returned].to_i) if @unit.trade.user
        Shop::Transaction.create!(user_id: @unit.trade.user_id, balance: @unit.trade.user.balance, change: params[:shop_unit][:amount_balance_returned], trade_id: @unit.trade.id, unit_id: @unit.id, editor_id: @current_user.id)
      end
      @unit.update_attributes!({amount_return_editor_id: @current_user.id, amount_returned_at: Time.now, transfer_editor_id: @current_user.id, transfer_at: Time.now, status: 'complete'}.update(params[:shop_unit].slice(:amount_balance_returned, :amount_returned)))
    end
    Shop::Sms.create!(:user_id => @unit.trade.user.id, :trade_id => @unit.trade.id, :phone => @unit.return_phone,
                      :content => "您的退款已由珀丽莱账户汇出，到账时间根据银行系统接转周期约1-7个工作日，可致电银行查询到账时间。如遇疑问请您致电客服电话查询反馈",
                      :editor_id => @current_user.id).send_by!(:service, @current_user) if @success && @unit.return_phone? && params[:sms] && params[:sms][:success]

    respond_to do |format|
      format.html { redirect_to request.referer || admin_shop_trade_path(@unit) }
      format.xml { render :xml => @unit }
    end

  end

  def split_new
    @trade = ::Shop::Trade.find(params[:id])
    raise unless @trade.freezable?
  end

  def split
    @trade = ::Shop::Trade.find(params[:id])
    @editor = @current_user
    @user = @trade.user

    database_transaction do
      @trade.update_attributes!(:status => 'freezed', :freeze_editor_id => @current_user.id, :freeze_at => Time.now)
      @trade.updated!(:status => @trade.status)
      @trade.units.each(&:returnit!)
      @trade.close_payment

      @trade.update_attributes!(:active => false) if params[:_destroy]

      (params[:groups]||{}).values.each do |unit_ids|
        trade = ::Shop::Trade.create!

        units = unit_ids.map(&:to_i).map { |unit_id| @trade.units.map.find { |u| u.id == unit_id } }
        raise if units.blank?

        trade.units = units.map do |u|
          unit = u.attributes.with_indifferent_access

          item = Shop::Item.find_by(id: unit[:item_id])
          raise 'invalid item' if item.try(:trade_id)

          product = item.try(:product) || Shop::Product.find_by(id: unit[:product_id])
          raise 'invalid product' unless product.try(:published?)
          raise 'invalid mall' unless !@user || [@user.malls, @user.level.try(:malls).to_a].flatten.include?(product.mall)

          if @user

            # unit[:percent]

            multibuy = Shop::Multibuy.find_by(id: unit[:multibuy_id].to_i) if unit[:multibuy_id].present?
            raise 'invalid multibuy' unless !multibuy || multibuy.published? && product.multibuy_id == multibuy.id && (percent = multibuy.percent_for(units.count { |unit| unit[:multibuy_id].to_i == multibuy.id })) > 0

            point_percent = unit[:point_percent].to_i
            point = point_percent == 100 ? product.point.to_i : point_percent * 1000
            raise 'invalid point_percent' unless product.mall.percent.to_i >= point_percent && (@user.percent.to_i >= point_percent || [0, 5, 10].include?(point_percent) || point_percent == 100 && product.point.to_i > 0)

            level_percent = unit[:level_percent].to_i
            raise 'invalid level_percent' unless @user.level.percent >= level_percent

            voucher = Shop::Voucher.f(unit[:voucher_id]) if unit[:voucher_id].present?
            raise 'invalid voucher' unless !voucher || voucher.user_id == @user.id && !voucher.trade_id && voucher.event.started_at <= Time.now && Time.now <= voucher.event.ended_at && product.discount >= voucher.event.limitation

            guide_percent = unit[:guide_percent].to_i
            raise 'invalid guide_percent' unless [product.mall.percent.to_i, @editor.guide.try(:percent).to_i].all? { |percent| percent >= guide_percent }
          end

          percent = [percent, level_percent, point_percent, guide_percent].map(&:to_i).find(&:nonzero?)
          raise 'multiple promotions' if ([!!params[:shop_user].try(:[], :password), !!voucher, !!multibuy, point_percent.to_i > 0, guide_percent.to_i > 0, level_percent.to_i > 0] - [false]).size > 1

          discount = @user ? product.discount : product.shop_price
          price = discount * (100 - percent.to_i) / 100
          price = discount - voucher.event.amount if voucher
          price = 0 if price < 0
          raise 'less than minimum_price' unless price >= product.minimum_price.to_i

          item.update_attributes!(trade_id: trade.id)
          voucher.update_attributes!(trade_id: trade.id) if voucher

          unit = Shop::Unit.new
          unit.attributes = {
              trade_id: trade.id,
              user_id: @user.try(:id),
              item_id: item.id,
              percent: percent,
              point_percent: point_percent,
              level_percent: level_percent,
              guide_percent: guide_percent,
              discount: product.discount,
              point: point,
              voucher_id: voucher.try(:id),
              multibuy_id: multibuy.try(:id),
              price: price,
          }
          product.sync_sell_data!
          unit
        end

        if (point = trade.units.map(&:point).map(&:to_i).inject(&:+)) && point > 0
          info = Core::Info.acquire(@user.id)
          raise 'invalid point' if point > info.point
          info.user.do_transaction!(-point, "购买时使用基因值抵折扣，交易ID=#{trade.id}")
        end

        # update trade information
        defaults = {
            original_id: @trade.id,
            editor_id: @editor.id,
            user_id: @user.try(:id),
            contact_id: @trade.contact.try(:id),
            invoice_contact_id: @trade.invoice_contact.try(:id),
            price: trade.units.map(&:price).inject(&:+).to_i,
            payment_price: trade.units.map(&:price).inject(&:+).to_i,
            status: 'pay',
            identifier: '%04d%02d%02d%02d%04d%06s' % [Time.now.year, Time.now.month, Time.now.day, rand(100), rand(10000), ((0..9).to_a*3+('A'..'Z').to_a).shuffle[0..5].join],
            checkout_token: SecureRandom.hex(16),
            client: 'manage',
            # guide_id: @editor.guide.try(:id),
            # shop_id: @editor.guide.try(:shop).try(:id),
        }.merge(@trade.attributes.slice(*%w[user_id contact_id invoice_contact_id delivery_time delivery_phone invoice_type invoice_title invoice_content comment package_from package_to package_content whisper_style whisper_from whisper_to whisper_content is_present shop_id shop_identifier guide_id mall_promotion_id remark]))
        trade.attributes = defaults
        trade.save!
        trade.updated!(status: trade.status)

        # give away with skipping payment if price is zero
        if trade.payment_price == 0
          trade.update_attributes!(status: 'audit', payment_service: 'giveaway')
          trade.updated!(status: trade.status)
        end

        if trade.shop
          trade.update_attributes!(status: 'audit', payment_service: 'shop')
          trade.updated!(status: trade.status)
        end
      end
    end
  end

  private

  def shop_authorized
    # return if !params[:id] || !@current_user.guide.try(:shop)
    return if !params[:id]
    @trade = ::Shop::Trade.find(params[:id])
    # not_authorized if @trade.shop != @current_user.guide.try(:shop)
    # not_authorized
  end
end
