##
# = 商城 交易 界面
#
class Shop::TradesController < Shop::ApplicationController

  ##
  # == 列表
  #
  # === Request
  #
  # ==== Resource
  #
  # GET /shop/trades
  #
  # ==== Parameters
  #
  # page :: 页数
  # per_page :: 每页个数
  #
  # === Response
  #
  # ==== JSON
  #
  #   {
  #     "trades" : [
  #       {
  #         ...
  #       },
  #     ],
  #   }
  #
  def index
    @trades = @current_user.trades.active._where(params[:where])._order(params[:order]).page(params[:page]).per(params[:per_page] || 10)
    respond_to do |format|
      format.html
      format.xml {
        case
          when params[:_format] == :xml
            render :action => 'index.xml', :layout => false, :content_type => Mime::XML.to_s
          when params[:_format] == :json
            render :action => 'index.json', :layout => false, :content_type => Mime::JSON.to_s
        end
      }
      #format.xml { @data = { 'trades' => @trades } }
    end
  end

  ##
  # == 查看
  #
  # === Request
  #
  # ==== Resource
  #
  # GET /shop/trades/:id
  #
  # ==== Parameters
  #
  # id :: 交易ID
  # \trade[checkout_token] :: 付款令牌(他人代付时生效)
  #
  # === Response
  #
  #
  # ==== JSON
  #
  # ===== default
  #
  # ===== JSON
  #
  #   {
  #     "trade" : {
  #       "id" : ID,
  #       "identifier" : 编号,
  #       "status" : 状态,
  #       "punishment" : 惩罚积分,
  #       "comment" : 留言,
  #       "price" : 成交价,
  #       "payment_price" : 支付价格,
  #       "payment_service" : 付款服务,
  #       "payment_identifier" : 付款标识,
  #       "delivery_service" : 快递服务,
  #       "delivery_identifier" : 快递标识,
  #       "delivery_time" : 快递时间,
  #       "delivery_phone" : 快递手机,
  #       "package_from" : 包装发送人,
  #       "package_to" : 包装接收人,
  #       "package_content" : 包装内容,
  #       "whisper_style" : 密语风格,
  #       "whisper_from" : 密语发送人,
  #       "whisper_to" : 密语接收人,
  #       "whisper_content" : 密语内容,
  #       "invoice_type" : 发票类型,
  #       "invoice_title" : 发票抬头,
  #       "invoice_content" : 发票内容,
  #       "invoice_delivery_service" : 发票快递服务,
  #       "invoice_delivery_identifier" : 发票快递编号,
  #       "created_at" : 创建时间,
  #       "updated_at" : 更新时间,
  #       "checkout_token" : 付款令牌,
  #       "checkout_name" : 代付人,
  #       "checkout_comment" : 代付留言,
  #       "contact" : {
  #         "id" : 联系方式ID,
  #         "user_id" : 用户ID,
  #         "name" : 名称,
  #         "country" : 国家,
  #         "province" : 身份,
  #         "city" : 城市,
  #         "town" : 区县,
  #         "address" : 地址,
  #         "postcode" : 邮编,
  #         "phone" : 电话,
  #         "mobile" : 手机,
  #       },
  #       "invoice_contact" : {
  #         "id" : 联系方式ID,
  #         "user_id" : 用户ID,
  #         "name" : 名称,
  #         "country" : 国家,
  #         "province" : 身份,
  #         "city" : 城市,
  #         "town" : 区县,
  #         "address" : 地址,
  #         "postcode" : 邮编,
  #         "phone" : 电话,
  #         "mobile" : 手机,
  #       },
  #       "units" : [
  #         {
  #           "id" : 单位ID,
  #           "circle_id" : 圈物ID,
  #           "price" : 成交价,
  #           "percent" : 折扣,
  #           "point" : 折扣积分,
  #           "bonus" : 奖励积分,
  #           "discount" : 悦购价,
  #           "contributed" : 投稿,
  #           "returned" : 退货,
  #           "status" : 退货状态,
  #           "return_phone" : 退款电话,
  #           "return_name" : 退款人,
  #           "return_bank" : 退款银行,
  #           "return_account" : 退款帐号,
  #           "return_branch" : 退款支行,
  #           "return_province" : 退款身份,
  #           "return_city" : 退款城市,
  #           "item" : {
  #             "id" : 单件ID,
  #             "identifer" : 编码,
  #             "measure" : 尺寸,
  #             "product" : {
  #               "id" : 产品ID,
  #               "label" : 备注,
  #               "prefix" : 前缀,
  #               "name" : 名称,
  #               "major_pic" : 主图片,
  #               "color_pic" : 颜色图片,
  #               "color_name" : 颜色名称,
  #               "hourglass_started_at" : 沙漏开始时间,
  #               "hourglass_rate" : 沙漏速率,
  #               "hourglass_pause_duration" : 沙漏暂停时长,
  #               "hourglass_trade_created_at" : 沙漏交易开始时间,
  #               "hourglass_trade_price" : 沙漏交易价格,
  #               "category2" : {
  #                 "id" : 分类ID,
  #                 "name" : 名称,
  #               },
  #               "brand" : {
  #                 "id" : 品牌ID,
  #                 "name" : 名称,
  #               },
  #             },
  #           },
  #           "voucher" : {
  #             "id" : 代金券ID,
  #             "user_id" : 用户ID,
  #             "event_id" : 券种ID,
  #             "trade_id" : 订单ID,
  #             "identifier" : 编号,
  #             "obtained_at" : 获得时间,
  #             "event" : {
  #               "id" : 券种ID,
  #               "name" : 名称,
  #               "description" : 描述,
  #               "amount" : 金额,
  #               "limitation" : 限制,
  #               "started_at" : 开始时间,
  #               "ended_at" : 结束时间,
  #             },
  #           },
  #           "multibuy": {
  #             "id": 连拍ID,
  #             "name": 名称,
  #           },
  #         },
  #       ],
  #     },
  #   }
  #
  # ===== others_to_pay
  #
  # ===== JSON
  #
  #   {
  #     "trade" : {
  #       "id" : ID,
  #       "identifier" : 编号,
  #       "status" : 状态,
  #       "price" : 成交价,
  #       "checkout_token" : 付款令牌,
  #       "checkout_name" : 代付人,
  #       "checkout_comment" : 代付留言,
  #       "payment_service" : 付款服务,
  #       "delivery_phone" : 快递手机,
  #       "created_at" : 创建时间,
  #       "user" : {
  #          "name" : 姓名,
  #        }
  #       "units" : [
  #         {
  #           "id" : 单位ID,
  #           "price" : 成交价,
  #           "item" : {
  #             "product" : {
  #               "name" : 名称,
  #             },
  #           },
  #         },
  #       ],
  #     },
  #   }
  #
  def show
    @trade = Shop::Trade.acquire(params[:id])

    respond_to do |format|
      format.html { @enable_lazyload = false }
      format.xml { @data = {'trade' => @current_user && @trade.user_id == @current_user.id ? @trade : @trade.assign_options(Shop::Trade.others_to_pay_xml_options)} }
    end
  end

  ##
  # == 查看购物车
  #
  # === Request
  #
  # ==== Resource
  #
  # GET /shop/trades/new
  #
  # ==== Parameters
  #
  # === Response
  #
  # ==== JSON
  #
  #   {
  #     units : [
  #       {
  #         'product_id' : 产品ID,
  #         'measure' : 尺寸,
  #         'percent' : 折扣,
  #         'quantity' : 数量,
  #       },
  #     ],
  #   }
  #
  def new
    @trade = Shop::Trade.new
    @cart = ActiveSupport::JSON.decode((@current_user ? @current_user.reload.cart_data : session[:cart_data]) || '[]') rescue []
    @cart ||= []
    @vouchers=@current_user.vouchers.active.joins('JOIN shop_events ON shop_events.id = shop_vouchers.event_id AND shop_events.started_at < NOW() AND shop_events.ended_at > NOW()').where('shop_vouchers.trade_id IS NULL').order('shop_vouchers.id DESC').limit(30) if @current_user
    respond_to do |format|
      format.html { @enable_lazyload = false }
      format.xml { @data = {'units' => @cart.map { |u| Unit.new(u) }.assign_options(:only => [:percent], :methods => [:product_id, :measure, :quantity])} }
    end
  end

  ##
  # == 创建
  #
  # === Request
  #
  # ==== Resource
  #
  # POST /shop/trades
  #
  # ==== Parameters
  #
  # good_id :: 物品ID
  # -
  # ticket_id :: 盒子ID
  # -
  # guess_id :: 猜价ID
  # guess_measure :: 猜价尺码
  # -
  # \units[][product_id] :: 产品ID
  # \units[][measure] :: 尺寸，默认为任意
  # \units[][percent] :: 折扣，默认为0，即将弃用
  # \units[][point_percent] :: 积分折扣
  # \units[][level_percent] :: 等级折扣
  # \units[][voucher_id] :: 代金券ID
  # \units[][multibuy_id] :: 连拍ID
  # \units[][quantity] :: 数量，可以为1..100，默认为1
  # -
  # \trade[is_present] :: 是否是礼品？
  # \trade[delivery_service] :: （已停用）快递服务，必须为{ 'fedex' => '联邦快递', 'zjs' => '宅急送', 'ems' => '邮政EMS' }之一
  # \trade[delivery_time] :: 快递时间，必须为{ 'workday' => '工作日', 'playday' => '休息日', 'all' => '皆可' }之一
  # \trade[delivery_phone] :: 快递手机
  # \trade[package_from] :: 包装发送人
  # \trade[package_to] :: 包装接收人
  # \trade[package_content] :: 包装内容
  # \trade[whisper_style] :: 密语风格
  # \trade[whisper_from] :: 密语发送人
  # \trade[whisper_to] :: 密语接收人
  # \trade[whisper_content] :: 密语内容
  # \trade[invoice_type] :: 发票类型，必须为{ 'personal' => '个人', 'company' => '公司' }之一
  # \trade[invoice_title] :: 发票抬头
  # \trade[invoice_content] :: 发票内容，必须为{ 'present' => '礼品', 'detail' => '商品明细' }之一
  # \trade[comment] :: 留言
  # \trade[contact][id] :: 联系方式ID，如果用户沿用上次联系方式则只传id
  # \trade[contact][name] :: 姓名
  # \trade[contact][country] :: 国家
  # \trade[contact][province] :: 身份
  # \trade[contact][city] :: 城市
  # \trade[contact][town] :: 区县
  # \trade[contact][address] :: 地址
  # \trade[contact][postcode] :: 邮编
  # \trade[contact][phone] :: 电话
  # \trade[contact][mobile] :: 手机
  # \trade[invoice_contact][id] :: 联系方式ID，如果用户沿用上次联系方式则只传id
  # \trade[invoice_contact][name] :: 姓名
  # \trade[invoice_contact][country] :: 国家
  # \trade[invoice_contact][province] :: 身份
  # \trade[invoice_contact][city] :: 城市
  # \trade[invoice_contact][town] :: 区县
  # \trade[invoice_contact][address] :: 地址
  # \trade[invoice_contact][postcode] :: 邮编
  # \trade[invoice_contact][phone] :: 电话
  # \trade[invoice_contact][mobile] :: 手机
  # \shop_user[password] :: 用户支付密码
  # \trade[client] :: 客户端类型, 必须为 %w[manage html5 osx windows linux flash iphone ipad android phone_web ipad_web wechat] 之一
  #
  # === Response
  #
  # ==== JSON
  #
  #   {
  #     "trade": {
  #
  #     }
  #   }
  #
  # ==== XML
  #
  # ==== YAML
  #
  def create
    @success = database_transaction do
      @user = @current_user
      @trade = Shop::Trade.create!(:status => 'pay', :checkout_token => SecureRandom.hex(16))

      # lock items by good or ticket or products
      @trade.units = if params[:good_id]
                       @good = Shop::Good.active.published.acquire(params[:good_id])
                       raise 'invalid good' if (@good.ended_at >= Time.now) || ((@good.top_bidder && @good.top_bidder.user) != @current_user) || @good.trade_id || !@good.item || @good.item.trade_id
                       @good.update_attributes!(:trade_id => @trade.id)
                       @good.item.update_attributes!(:trade_id => @trade.id)
                       @good.item.product.sync_sell_data!
                       Unit.new(
                         :trade_id => @trade.id,
                         :item_id => @good.item.id,
                         :discount => @good.item.product.discount,
                         :price => @good.item.product.discount,
                         :percent => 0,
                         :point => 0
                       ).to_a
                     elsif params[:ticket_id]
                       @ticket = Shop::Ticket.acquire(params[:ticket_id])
                       raise 'invalid ticket' if !@ticket.published && !@ticket.lottery.valid_time? || @ticket.trade_id || @current_user.find_lottery_is_success(@ticket.lottery.id, @ticket.id).count == 0 || !@ticket.item || @ticket.item.trade_id
                       @ticket.update_attributes!(:trade_id => @trade.id, :user_id => @current_user.id)
                       @ticket.item.update_attributes!(:trade_id => @trade.id)
                       @ticket.item.product.sync_sell_data!
                       Unit.new(
                         :trade_id => @trade.id,
                         :item_id => @ticket.item.id,
                         :discount => @ticket.item.product.discount,
                         :price => @ticket.item.product.discount,
                         :percent => 0,
                         :point => 0
                       ).to_a
                     elsif params[:guess_id]
                       @guess = Shop::Guess.active.published.find(params[:guess_id])
                       @chance = @guess.chances.find_by_user_id(@current_user.id)
                       raise 'invalid guess' if @chance.price.blank?
                       raise 'invalid product' unless (product = @guess.product) && product.published?
                       raise 'item sold out' unless (items = product.items.published.unsold.where(params[:guess_measure].blank? ? nil : ["measure = ?", params[:guess_measure].to_s]).limit(1).order(Shop::Category::PRIORITIES.map { |p| {p[:name] => p[:order]} }.inject({}, &:merge)[product.category2 && product.category2.priority] || (Shop::Category::PRIORITIES.first||{})[:order]).to_a) && (items.size == 1)
                       units = items.map do |item|
                         item.update_attributes!(:trade_id => @trade.id)
                         Unit.new(
                           :trade_id => @trade.id,
                           :item_id => item.id,
                           :percent => 0,
                           :discount => product.discount,
                           :point => 0,
                           :price => @chance.price
                         )
                       end
                       @guess.update_attribute :dicker_price, @chance.price if @guess.dicker_price.to_i < @chance.price
                       items.first.product.sync_sell_data!
                       units
                     elsif params[:units]
                       params[:units] = params[:units].values if params[:units].is_a?(Hash)
                       # debugger
                       params[:units].map do |u|
                         product = Shop::Product.acquire(u[:product_id])
                         raise 'invalid product' unless (product = Shop::Product.acquire(u[:product_id])) && product.published? # && product.published_at && Time.now > product.published_at
                         # raise 'invalid mall' unless (@current_user.malls + (@current_user.level ? @current_user.level.malls : [])).include?(product.mall)
                         raise 'cannot use balance or percent or voucher at the same time' if ([!!params[:shop_user].try(:[], :password), (u[:percent].to_i > 0), (u[:point_percent].to_i > 0), (u[:level_percent].to_i > 0), u[:voucher_id].present?, u[:multibuy_id].present?] - [false]).size > 1
                         # raise 'invalid percent' unless (percent = u[:percent].to_i) && product.mall.percent.to_i >= percent && ((@user.percent || @user.level.percent || 0) >= percent || [0, 5, 10].include?(percent) || percent == 100 && product.point.to_i > 0 || u[:multibuy_id].present?)
                         raise 'invalid percent' unless (percent = u[:percent].to_i) && ((@user.percent || @user.level.percent || 0) >= percent || [0, 5, 10].include?(percent) || percent == 100 && product.point.to_i > 0 || u[:multibuy_id].present?)
                         raise 'invalid voucher' unless u[:voucher_id].blank? || (voucher = Shop::Voucher.acquire(u[:voucher_id])) && voucher.user_id == @current_user.id && voucher.event.started_at <= Time.now && Time.now <= voucher.event.ended_at && product.discount >= voucher.event.limitation && !voucher.trade
                         # raise 'invalid multibuy' unless u[:multibuy_id].blank? || (multibuy = Shop::Multibuy.acquire(u[:multibuy_id])) && multibuy.published? && product.multibuy_id == multibuy.id && (percent = multibuy.percent_for(params[:units].count { |unit| unit[:multibuy_id].to_i == multibuy.id })) > 0
                         raise 'invalid point_percent' unless (point_percent = u[:point_percent].to_i) && ((@user.percent || 0) >= point_percent || [0, 5, 10].include?(point_percent) || point_percent == 100 && product.point.to_i > 0)
                         # raise 'invalid level_percent' unless (level_percent = u[:level_percent].to_i) && [product.mall.percent.to_i, @user.level.percent].all?{ |p| p >= level_percent }
                         raise 'invalid level_percent' unless (level_percent = u[:level_percent].to_i) && [@user.level.percent].all? { |p| p >= level_percent }
                         if percent.present? && percent > 0
                           if @user.level.percent >= percent
                             level_percent = percent
                           else
                             point_percent = percent
                           end
                         end
                         raise 'invalid quantity' unless (quantity = (u[:quantity] || 1).to_i) && 1 <= quantity && quantity <= 100
                         raise 'item sold out' unless (items = product.items.published.unsold.where(u[:measure].blank? ? nil : ["measure = ?", u[:measure]]).limit(quantity).order(Shop::Category::PRIORITIES.map { |p| {p[:name] => p[:order]} }.inject({}, &:merge)[product.category2 && product.category2.priority] || (Shop::Category::PRIORITIES.first||{})[:order]).to_a) && (items.size == quantity)
                         current_percent = percent.present? && !percent.zero? && percent || point_percent.present? && !point_percent.zero? && point_percent || level_percent.present? && !level_percent.zero? && level_percent
                         price = case
                                   when voucher.present?
                                     p = product.discount - voucher.event.amount
                                     p >= 0 ? p : 0
                                   when current_percent.present?
                                     product.discount*(100-current_percent)/100
                                   else
                                     product.discount
                                 end
                         raise 'less than minimum_price' unless price >= product.minimum_price.to_i
                         percent = [point_percent, level_percent].max if percent == 0 && [point_percent, level_percent].any? { |p| p > 0 }
                         units = items.map do |item|
                           item.update_attributes!(:trade_id => @trade.id)
                           voucher.update_attributes!(:trade_id => @trade.id) if voucher
                           Shop::Unit.new(
                             :trade_id => @trade.id,
                             :item_id => item.id,
                             :percent => percent,
                             point_percent: point_percent,
                             level_percent: level_percent,
                             :discount => product.discount,
                             # point: point_percent == 100 ? product.point.to_i : point_percent*1000,
                             :voucher_id => voucher && voucher.id,
                             # multibuy_id: multibuy.try(:id),
                             :price => price
                           )
                         end

                         if !u[:measure].blank? && (row = CSV.parse(product.measure_table.to_s.strip).find { |t| t[1] == u[:measure] }.to_a.drop(2)) && !row.blank? && (properties = product.category2.measure_properties.to_s.split(',')) && !properties.blank? && (preferences = @current_user.preferences.active) && preferences.count <= 1
                           preference = preferences.first || Preference.new(:user => @current_user)
                           preference.name ||= '我'
                           preference.gender ||= @current_user.sex
                           Shop::Category::MEASURE_PROPERTIES.each { |field, name| preference[field] ||= (i = properties.index(name)) && !row[i].blank? && !product.category2["#{field}_offset"].blank? && row[i].to_i - product.category2["#{field}_offset"] || nil }
                           preference.save!
                         end

                         items[0].product.sync_sell_data!
                         units
                       end.flatten
                     end
      raise 'invalid units' if @trade.units.blank?

      # decrypt params with leading string 'Ns5Y'
      if trade_params
        %w[delivery_time delivery_phone invoice_type invoice_title invoice_content comment package_from package_to package_content whisper_style whisper_from whisper_to whisper_content is_present].each { |field| (v = trade_params[field]) && v.match(/^Ns5Y/) && (trade_params[field] = Base64.decode64(v.sub(/^Ns5Y/, '')).force_encoding('utf-8')) }
        %w[id name country province city town address postcode  mobile].each { |field| (v = trade_params[:contact][field]) && v.match(/^Ns5Y/) && (trade_params[:contact][field] = Base64.decode64(v.sub(/^Ns5Y/, '')).force_encoding('utf-8')) } if trade_params[:contact]
        %w[id name country province city town address postcode  mobile].each { |field| (v = trade_params[:invoice_contact][field]) && v.match(/^Ns5Y/) && (trade_params[:invoice_contact][field] = Base64.decode64(v.sub(/^Ns5Y/, '')).force_encoding('utf-8')) } if trade_params[:invoice_contact]
      end
      # use last contact or create new if data changed
      if trade_params && trade_params[:contact]
        @contact = (id = trade_params[:contact][:id]) && !id.empty? && (Shop::Contact.acquire(id) rescue nil)
        @contact = nil if @contact && !%w[name country province city town address postcode  mobile].map { |f| @contact[f] == trade_params[:contact][f] }.inject(&:&)
        @contact ||= Shop::Contact.find_by(trade_params[:contact].slice('name', 'country', 'province', 'city', 'town', 'address', 'postcode', 'mobile').merge(user_id: @current_user.id))
        @contact ||= Shop::Contact.create!(trade_params[:contact].merge(:user_id => @current_user.id, :id => nil))
      end
      raise 'invalid contact' unless @contact

      # create new invoice contact or use invoice contact
      if trade_params && trade_params[:invoice_contact]
        trade_params[:invoice_contact][:id] = @contact.id if trade_params[:invoice_contact][:id].blank?
        @invoice_contact = (id = trade_params[:invoice_contact][:id]) && !id.blank? && (Shop::Contact.acquire(id) rescue nil)
        @invoice_contact = nil if @invoice_contact && !%w[name country province city town address postcode phone mobile].map { |f| @invoice_contact[f] == trade_params[:invoice_contact][f] }.inject(&:&)
        @invoice_contact ||= Shop::Contact.find_by(trade_params[:invoice_contact].slice('name', 'country', 'province', 'city', 'town', 'address', 'postcode', 'phone', 'mobile').merge(user_id: @current_user.id))
        @invoice_contact ||= Shop::Contact.create!(trade_params[:invoice_contact].merge(:user_id => @current_user.id, :id => nil))
        raise 'invalid invoice contact' unless @invoice_contact
      end

      # deduct point if need
      # if (point = @trade.units.map(&:point).inject(&:+)) && point > 0
      # 	info = Core::Info.acquire(@current_user.id)
      # 	raise 'invalid point' if point > info.point
      # 	info.user.do_transaction!(-point, "购买时使用积分抵折扣，交易ID=#{@trade.id}")
      # end

      payment_price = price = @trade.units.map(&:price).inject(&:+)
      if params[:shop_user] && params[:shop_user][:password]
        raise unless @current_user.crypted_password == Core::Account.find(@current_user.id).encrypt(params[:shop_user][:password])
        balance = @current_user.balance
        @current_user.cards.active.published.where(["balance > 0 AND started_at < ? AND ended_at > ?", Time.now, Time.now]).order('ended_at ASC').each do |card|
          break if balance >= price
          balance += card.balance
          @current_user.transactions.create!(:card_id => card.id, :change => card.balance, :balance => balance)
          card.update_attributes!(:balance => 0)
        end
        if (change = -[balance, price].min) != 0
          payment_price += change
          balance += change
          @current_user.transactions.create!(:trade_id => @trade.id, :change => change, :balance => balance)
          @current_user.update_attributes!(:balance => balance)
        end
      end

      # update trade information
      @trade.update_attributes!({
                                  :user_id => @current_user.id,
                                  :contact_id => @contact && @contact.id,
                                  :invoice_contact_id => @invoice_contact && @invoice_contact.id,
                                  :price => price,
                                  :payment_price => payment_price,
                                  :status => 'pay',
                                  :identifier => '%04d%02d%02d%02d%04d%06s' % [Time.now.year, Time.now.month, Time.now.day, ((@trade.units[0].item.product.category2_id||0) % 100), (@trade.units[0].item.product_id % 10000), ((0..9).to_a*3+('A'..'Z').to_a).shuffle[0..5].join],
                                  :delivery_phone=>trade_params[:delivery_phone]||trade_params[:contact][:mobile]
                                }.merge(trade_params.slice(:delivery_time, :invoice_type, :invoice_title, :invoice_content, :comment, :package_from, :package_to, :package_content, :whisper_style, :whisper_from, :whisper_to, :whisper_content, :is_present, :client)).merge(cookies.instance_variable_get('@cookies').slice(*%w[link_id click_id latest_link_id latest_click_id])))
      # @trade.updated!(:status => @trade.status)

      # give away with skipping payment if price is zero
      if @trade.payment_price == 0
        @trade.update_attributes!(:status => 'audit', :payment_service => 'giveaway')
        # @trade.updated!(:status => @trade.status)
      end

      # empty cart
      @current_user && @current_user.update_attributes!(:cart_data => '[]')
      session[:cart_data] = nil
    end
    if @success
      respond_to do |format|
        format.html { redirect_to params[:redirect] || shop_trade_path(@trade) }
        format.js { render :text => @trade.to_json }
        format.xml { @data = {'trade' => @trade} }
      end
    else
      respond_to do |format|
        format.html { redirect_to request.referer || shop_trade_path(@trade) }
        format.js { raise }
        format.xml { raise ActiveRecord::RecordInvalid.new(@trade||Shop::Trade.new) }
      end
    end
  end

  def edit # :nodoc:
    @trade = Shop::Trade.acquire(params[:id])

    if @trade.user_id != @current_user.id || !%[pay audit].include?(@trade.status)
      not_authorized
      return
    end

    respond_to do |format|
      format.html
      format.xml { @data = {'trade' => @trade} }
    end
  end

  ##
  # == 更新
  #
  # === Request
  #
  # ==== Resource
  #
  # PUT /shop/trades/:id
  #
  # ==== Parameters
  #
  # id :: 订单id
  # \trade[is_present] :: 是否是礼品？
  # \trade[delivery_service] :: （已停用）快递服务，必须为{ 'fedex' => '联邦快递', 'zjs' => '宅急送', 'ems' => '邮政EMS' }之一
  # \trade[delivery_time] :: 快递时间，必须为{ 'workday' => '工作日', 'playday' => '休息日', 'all' => '皆可' }之一
  # \trade[package_from] :: 包装发送人
  # \trade[package_to] :: 包装接收人
  # \trade[package_content] :: 包装内容
  # \trade[whisper_style] :: 密语风格
  # \trade[whisper_from] :: 密语发送人
  # \trade[whisper_to] :: 密语接收人
  # \trade[whisper_content] :: 密语内容
  # \trade[invoice_type] :: 发票类型，必须为{ 'personal' => '个人', 'company' => '公司' }之一
  # \trade[invoice_title] :: 发票抬头
  # \trade[invoice_content] :: 发票内容，必须为{ 'present' => '礼品', 'detail' => '商品明细' }之一
  # \trade[comment] :: 留言
  # \trade[checkout_comment] :: 代付留言
  # \trade[checkout_token] : 付款令牌
  # \trade[contact][id] :: 联系方式ID，如果用户沿用上次联系方式则只传id
  # \trade[contact][name] :: 姓名
  # \trade[contact][country] :: 国家
  # \trade[contact][province] :: 身份
  # \trade[contact][city] :: 城市
  # \trade[contact][town] :: 区县
  # \trade[contact][address] :: 地址
  # \trade[contact][postcode] :: 邮编
  # \trade[contact][phone] :: 电话
  # \trade[contact][mobile] :: 手机
  # -
  # \trade[invoice_contact][id] :: 联系方式ID，如果用户沿用上次联系方式则只传id
  # \trade[invoice_contact][name] :: 姓名
  # \trade[invoice_contact][country] :: 国家
  # \trade[invoice_contact][province] :: 身份
  # \trade[invoice_contact][city] :: 城市
  # \trade[invoice_contact][town] :: 区县
  # \trade[invoice_contact][address] :: 地址
  # \trade[invoice_contact][postcode] :: 邮编
  # \trade[invoice_contact][phone] :: 电话
  # \trade[invoice_contact][mobile] :: 手机
  #
  # === Response
  #
  # 返回一条Shop::Shop::Trade
  #
  def update
    @trade = Shop::Trade.acquire(params[:id])

    if !%w[pay audit].include?(@trade.status)
      not_authorized
      return
    end

    trade_params.slice!(:checkout_comment, :checkout_name) unless @current_user && @trade.user_id == @current_user.id

    @success = database_transaction do
      @contact = @trade.contact
      if trade_params[:contact]
        @contact = nil if @contact && !%w[name country province city town address postcode phone mobile].map { |f| @contact[f] == trade_params[:contact][f] }.inject(&:&)
        @contact ||= Shop::Contact.find_by(trade_params[:contact].slice('name', 'country', 'province', 'city', 'town', 'address', 'postcode', 'phone', 'mobile').merge(user_id: @current_user.id))
        @contact ||= Shop::Contact.create!(trade_params[:contact].merge(:user_id => @current_user.id))

        @invoice_contact = @trade.invoice_contact
        if trade_params && trade_params[:invoice_contact]
          @invoice_contact = nil if @invoice_contact && !%w[name country province city town address postcode phone mobile].map { |f| @invoice_contact[f] == trade_params[:invoice_contact][f] }.inject(&:&)
          @invoice_contact ||= Shop::Contact.find_by(trade_params[:invoice_contact].slice('name', 'country', 'province', 'city', 'town', 'address', 'postcode', 'phone', 'mobile').merge(user_id: @current_user.id))
          @invoice_contact ||= Shop::Contact.create!(trade_params[:invoice_contact].merge(:user_id => @current_user.id))
        end
      end

      @trade.update_attributes!(trade_params.slice(:delivery_time, :invoice_type, :invoice_title, :invoice_content, :comment, :checkout_comment, :checkout_name, :package_from, :package_to, :package_content, :whisper_style, :whisper_from, :whisper_to, :whisper_content, :is_present).merge(:contact => @contact, :invoice_contact => @invoice_contact))
    end

    if @success
      # Core::Mailer.mail(
      # 	:recipients => "info@barlar.cn",
      # 	:subject => "订单#{@trade.identifier}已成功付款（免费赠送）",
      # 	:template => 'shop_pay_manage',
      # 	:body => { :trade => @trade }
      # ) if @trade.payment_price.zero?

      respond_to do |format|
        format.html { redirect_to params[:redirect] || shop_trade_path(@trade) }
        format.xml { @data = {'trade' => @current_user && @trade.user_id == @current_user.id ? @trade.assign_options(Shop::Trade.xml_options.deep_clone.delete(:methods)) : @trade.assign_options(Shop::Trade.others_to_pay_xml_options)} }
      end
    else
      respond_to do |format|
        format.html { redirect_to request.referer || shop_trade_path(@trade) }
        format.xml { raise ActiveRecord::RecordInvalid.new(@trade||Shop::Trade.new) }
      end
    end
  end

  ##
  # == 选择货到付款
  #
  # === Request
  #
  # ==== Resource
  #
  # PUT /shop/trades/:id/express_pay
  #
  # ==== Parameters
  #
  # id :: 交易ID
  # \trade[delivery_phone] :: 快递手机
  #
  # === Response
  #
  # 返回一条交易Shop::Shop::Trade
  #
  def express_pay
    @trade = Shop::Trade.acquire(params[:id])

    if  @trade.user_id != @current_user.id || @trade.status != 'pay'
      not_authorized
      return
    end

    @success = database_transaction do
      @trade.update_attributes!(trade_params.slice(:delivery_phone)) if trade_params
      @trade.audit!(:payment_service => 'express')
    end

    if @success
      # Core::Mailer.mail(
      # 	:recipients => @account.email,
      # 	:subject => "您的订单#{@trade.identifier}已申请货到付款",
      # 	:template => 'shop_express_pay',
      # 	:body => { :trade => @trade }
      # ) if @trade.payment_service == 'express' && (@account = Core::Account.find(@trade.user)) && @account.user.setting.receive_promotion_email?

      respond_to do |format|
        format.html { redirect_to params[:redirect] || shop_trade_path(@trade) }
        format.js { render :text => "" }
        format.xml { @data = {'trade' => @trade} }
      end
    else
      respond_to do |format|
        format.html { redirect_to params[:redirect] || shop_trade_path(@trade) }
        format.js { raise }
        format.xml { @data = {'trade' => @trade} }
      end
    end
  end

  ##
  # == 外部支付页面
  #
  # === Request
  #
  # ==== Resource
  #
  # GET /shop/trades/:id/checkout
  #
  # ==== Parameters
  #
  # id :: 交易ID
  # \trade[checkout_token] :: 付款令牌(他人代付时生效)
  # \trade[payment_service] :: 付款服务，可以为%w[alipay alipay_qr alipay_网银代码 alipay_moto alipay_creditcard_快捷代码 alipay_installment alipay_installment_分期代码 bill99 bill99_银行代码 unionpay lakala cmbchina cmbchina_wap ccb cmbc pab pgs boc_creditcard boc alipay_wap unionpay_wap comm_creditcard yeepay yeepay_预付卡代码 cmbchina_creditcard_分期代码 wechat pab_pay icbc]之一，银行代码列表请见Shop::Shop::Trade
  # redirect :: 跳转地址（仅限于cmbchina cmbchina_wap）
  #
  # === Response
  #
  # ==== HTML
  #
  # 重定向到付款页面
  #
  # ==== XML
  #
  #   <response>
  #     <url>地址</url>
  #   </response>
  #
  # ==== JSON
  #
  #   {
  #     "url" : 地址,
  #   }
  #
  def checkout
    @trade = Shop::Trade.acquire(params[:id])
    service = trade_params && trade_params[:payment_service]
    url = case service
            when 'alipay'
              @trade.alipay_checkout_url(nil, {'exter_invoke_ip' => request.remote_ip}.merge((connection = Core::Connection.find_by_site_and_account_id('alipay', @current_user && @current_user.id)) ? {'token' => connection.token} : {}))
            when 'cmbchina'
              @trade.cmbchina_checkout_url(:redirect => params[:redirect])
            when 'cmbchina_wap'
              @trade.cmbchina_checkout_url(:type => 'wap', :redirect => params[:redirect])
            when /^cmbchina_creditcard_?/
              @trade.cmbchina_creditcard_checkout_url(service.sub(/^cmbchina_creditcard_?/, ''))
            when 'lakala'
              @trade.lakala_checkout_url
            when 'ccb'
              @trade.ccb_checkout_url
            when 'bill99'
              @trade.bill99_checkout_url
            when /^bill99_?/
              @trade.bill99_checkout_url(service.sub(/^bill99_?/, ''))
            when /^alipay_?/
              puts "#####{@trade.id}"
              @trade.alipay_checkout_url(service.sub(/^alipay_?/, ''), {'exter_invoke_ip' => request.remote_ip}.merge((connection = Core::Connection.find_by_site_and_account_id('alipay', @current_user && @current_user.id)) ? {'token' => connection.token} : {}))
            when 'unionpay'
              @trade.unionpay_checkout_url(request.remote_ip)
            when 'unionpay_wap'
              render :text => @trade.unionpay_wap_checkout_url
              return
            when 'cmbc'
              @trade.cmbc_checkout_url
            when 'pab'
              @trade.pab_checkout_url
            when 'pab_pay'
              @trade.pab_pay_checkout_url
            when 'pgs'
              @trade.pgs_checkout_url
            when 'boc_creditcard'
              @trade.boc_creditcard_checkout_url(request.remote_ip)
            when 'boc'
              @trade.boc_checkout_url
            when 'comm_creditcard'
              @trade.comm_creditcard_checkout_url
            when 'yeepay'
              @trade.yeepay_checkout_url
            when /^yeepay_?/
              @trade.yeepay_checkout_url(service.sub(/^yeepay_?/, ''))
            when 'wechat'
              connection=@current_account.connections.where(site: "wechat").first
              render(json: @trade.wechat_checkout_url(request.remote_ip, connection && connection.identifier))
              return
            when 'icbc'
              @trade.icbc_checkout_url
          end

    respond_to do |format|
      format.html { redirect_to url }
      format.xml { @data = {'url' => url} }
    end
  end

  def unionpay_wap_return
    @trade = Shop::Trade.acquire(params[:id])

    if @trade.status != 'pay'
      render :text => "success", :layout => false
      return
    end

    unless params[:signature] == Digest::MD5.hexdigest("#{params.except(*%w[controller action id signMethod signature ]).reject { |k, v| v.blank? }.sort.map { |k, v| "#{k}=#{v}" }.join("&")}&"+Digest::MD5.hexdigest(PAYMENT_CONFIG['unionpay_wap']['securityKey']))
      render :text => "failure", :layout => false
      return
    end

    @success = database_transaction do
      @trade.audit!(:payment_service => 'unionpay_wap', :payment_identifier => params[:qn])
    end

    if @success
      render :text => "success", :layout => false
    else
      render :text => "failure", :layout => false
    end
  end

  def alipay_wallet_return
    @trade = Shop::Trade.acquire(params[:id])

    if @trade.status != 'pay'
      render text: "success", layout: false
      return
    end

    notify_doc = Nokogiri::XML.parse(params['notify_data'].to_s)

    unless %w[TRADE_SUCCESS TRADE_FINISHED].include?(notify_doc.xpath('notify/trade_status').text) && notify_doc.xpath('notify/total_fee').text.to_f == @trade.payment_price && OpenSSL::PKey::RSA.new(PAYMENT_CONFIG['alipay']['server_public_key']).verify(OpenSSL::Digest::SHA1.new, Base64.decode64(params['sign'].to_s), "notify_data=#{params['notify_data'].to_s}")
      render text: "failure", layout: false
      return
    end

    @success = database_transaction do
      @trade.audit!(payment_service: 'alipay_wallet', payment_identifier: notify_doc.xpath('notify/trade_no').text)
    end

    if @success
      render text: "success", layout: false
    else
      render text: "failure", layout: false
    end
  end

  def alipay_return # :nodoc:
    @trade = Shop::Trade.acquire(params[:id])

    if @trade.status != 'pay'
      if params[:source] == 'notify'
        render :text => "success", :layout => false
      else
        redirect_to payment_success_shop_trades_path
      end
      return
    end

    unless params['sign'].downcase == Digest::MD5.hexdigest(params.except(*%w[controller action id sign_type sign source]).sort.map { |k, v| "#{k}=#{k == 'notify_id' ? v : CGI.unescape(v)}" }.join("&")+PAYMENT_CONFIG['alipay']['key'])
      if params[:source] == 'notify'
        render :text => "failure", :layout => false
      else
        redirect_to payment_failure_shop_trades_path
      end
      return
    end

    @success = database_transaction do
      @trade.audit!(:payment_service => 'alipay', :payment_identifier => params['trade_no'])
    end

    if @success
      if params[:source] == 'notify'
        render :text => "success", :layout => false
      else
        redirect_to payment_success_shop_trades_path
      end
    else
      if params[:source] == 'notify'
        render :text => "failure", :layout => false
      else
        redirect_to payment_failure_shop_trades_path
      end
    end
  end

  def cmbchina_return # :nodoc:
    @trade = Shop::Trade.acquire(params[:id])

    if @trade.status != 'pay'
      redirect_to params[:redirect] || '/statics/shop/payment/result/success.html'
      return
    end

    unless (params[:Amount].to_f - @trade.payment_price.to_f).zero? && CMBCHINA::Security.checkInfoFromBank("Succeed=#{params[:Succeed]}&CoNo=#{PAYMENT_CONFIG['cmbchina']['CoNo']}&BillNo=#{params[:BillNo]}&Amount=#{params[:Amount]}&Date=#{params[:Date]}&MerchantPara=#{params[:MerchantPara]}&Msg=#{params[:Msg]}&Signature=#{params[:Signature]}")
      redirect_to params[:redirect] || '/statics/shop/payment/result/failure.html'
      return
    end

    @success = database_transaction do
      @trade.audit!(:payment_service => 'cmbchina', :payment_identifier => params[:Msg][-20..-1])
    end

    if @success
      redirect_to params[:redirect] || '/statics/shop/payment/result/success.html'
    else
      redirect_to params[:redirect] || '/statics/shop/payment/result/failure.html'
    end
  end

  def cmbchina_creditcard_return # :nodoc:
    @trade = Shop::Trade.acquire(params[:id])

    if @trade.status != 'pay'
      redirect_to params[:redirect] || '/statics/shop/payment/result/success.html'
      return
    end

    notice = Nokogiri::XML::Document.parse(params[:Notice].delete('$')).css('CDPNotice_Pay')
    unless notice.css("Body/ResultFlag").text == 'Y' && notice.css("Body/MchMchNbr").text == PAYMENT_CONFIG['cmbchina_creditcard']['CoNo'] && notice.css("Body/TrxBllAmt").text.try(:to_i) == @trade.payment_price && CMBCHINA_CREDITCARD::Security.CheckSign(params[:Notice].match(/<\$Head\$>.*<\/\$Body\$>/).to_s.encode('UTF-8', 'GB2312').unpack('c*'), get_sign_bytes(notice.css("Signature").text))
      redirect_to '/statics/shop/payment/result/failure.html'
      return
    end

    @success = database_transaction do
      @trade.audit!(:payment_service => 'cmbchina_creditcard')
    end

    if @success
      redirect_to '/statics/shop/payment/result/success.html'
    else
      redirect_to '/statics/shop/payment/result/failure.html'
    end
  end

  def bill99_return # :nodoc:
    @trade = Shop::Trade.acquire(params[:id])

    if @trade.status != 'pay'
      respond_to do |format|
        format.html { redirect_to '/statics/shop/payment/result/success.html' }
        format.xml { render :text => "<result>1</result><redirecturl>http://#{HOSTS['dynamic']}/shop/trades/#{@trade.id}/bill99_return</redirecturl>" }
      end
      return
    end

    cert = OpenSSL::X509::Certificate.new(PAYMENT_CONFIG['bill99']['server_public_key']) rescue nil
    is_valid = cert && cert.public_key.verify(OpenSSL::Digest::SHA1.new, Base64.decode64(params[:signMsg]), (%w[merchantAcctId version language signType payType bankId orderId orderTime orderAmount dealId bankDealId dealTime payAmount fee ext1 ext2 payResult errCode].map { |k| (v=params[k]) && !v.blank? ? [k, v] : nil }.compact).map { |k, v| "#{k}=#{v}" }.join('&'))

    unless params[:payResult] == "10" && params[:orderAmount] == (@trade.payment_price * 100).to_i.to_s && is_valid
      respond_to do |format|
        format.html { redirect_to '/statics/shop/payment/result/failure.html' }
        format.xml { render :text => "<result>0</result>" }
      end
      return
    end

    @success = database_transaction do
      @trade.audit!(:payment_service => params[:bankId] ? "bill99_#{params[:bankId].downcase}" : "bill99")
    end

    if @success
      respond_to do |format|
        format.html { redirect_to '/statics/shop/payment/result/success.html' }
        format.xml { render :text => "<result>1</result><redirecturl>http://#{HOSTS['dynamic']}/shop/trades/#{@trade.id}/bill99_return</redirecturl>" }
      end
    else
      respond_to do |format|
        format.html { redirect_to '/statics/shop/payment/result/failure.html' }
        format.xml { render :text => "<result>0</result>" }
      end
    end
  end

  def lakala_return # :nodoc:
    raise 'incorrect signature' unless params[:sign] == Digest::MD5.hexdigest(params.slice(*(%w[amount lakala_query_time mer_id req_id sec_id service trade_no v]+%w[amount amount_pay currency lakala_bill_no lakala_pay_time mer_id partner_bill_no pay_type req_id service trade_no v]).uniq).sort.map { |k, v| "#{k}=#{v}" }.join('&')+PAYMENT_CONFIG['lakala']['mer_key'])

    case params[:service]
      when 'lakala.agency.tradePayConsultBalance'
        @trade = Shop::Trade.find_by_id(params[:trade_no])
        options = params.slice(*%w[v service mer_id sec_id req_id]).merge(
          :can_pay => @trade.status != 'pay' ? 'n' : @trade.payment_price == params[:amount].to_i ? 'y' : '001',
          :amount => @trade && @trade.payment_price,
          :partner_bill_no => @trade && @trade.id,
          :partner_query_time => Time.now.to_s(:db),
          :partner_extendinfo => ''
        )
      when 'lakala.agency.tradePayBalance'
        @trade = Shop::Trade.find_by_id(params[:partner_bill_no])
        is_success = @trade && params[:amount].to_i == @trade.payment_price && params[:amount_pay].to_i == @trade.payment_price && params[:currency] == '156' && database_transaction { @trade.audit!(:payment_service => 'lakala', :payment_identifier => params[:lakala_bill_no]) }
        options = params.slice(*%w[v service mer_id sec_id req_id lakala_bill_no partner_bill_no]).merge(
          :is_success => is_success ? 'y' : 'n',
          :partner_pay_time => Time.now.strftime('%Y%m%d%H%M%S')
        )
    end

    options.merge!(:sign => Digest::MD5.hexdigest(options.sort.map { |k, v| "#{k}=#{v}" }.join('&')+PAYMENT_CONFIG['lakala']['mer_key']))
    render :text => options.sort.map { |k, v| "#{k}=#{v}" }.join('&')
  end

  def ccb_return # :nodoc:
    @trade = Shop::Trade.acquire(params[:ORDERID])

    if @trade.status != 'pay'
      redirect_to '/statics/shop/payment/result/success.html'
      return
    end

    unless params['SUCCESS'] == 'Y' && params['PAYMENT'].to_f == @trade.payment_price && Shop::Trade.ccb_verify(params['SIGN'], %w[POSID BRANCHID ORDERID PAYMENT CURCODE REMARK1 REMARK2 SUCCESS].map { |field| "#{field}=#{params[field]}" }.join('&'))
      redirect_to '/statics/shop/payment/result/failure.html'
      return
    end

    @success = database_transaction do
      @trade.audit!(:payment_service => 'ccb')
    end

    if @success
      redirect_to '/statics/shop/payment/result/success.html'
    else
      redirect_to '/statics/shop/payment/result/failure.html'
    end
  end

  def unionpay_return # :nodoc:
    @trade = Shop::Trade.acquire(params[:id])

    if @trade.status != 'pay'
      if params[:source] == 'notify'
        render :text => "success", :layout => false
      else
        redirect_to '/statics/shop/payment/result/success.html'
      end
      return
    end
    unionpay_data = @trade.unionpay_result
    unless unionpay_data[:queryResult] == '0' && unionpay_data[:settleAmount].to_i == @trade.payment_price*100
      if params[:source] == 'notify'
        render :text => "failure", :layout => false
      else
        redirect_to '/statics/shop/payment/result/failure.html'
      end
      return
    end

    @success = database_transaction do
      @trade.audit!(:payment_service => 'unionpay', :payment_identifier => unionpay_data[:qid])
    end
    if @success
      if params[:source] == 'notify'
        render :text => "success", :layout => false
      else
        redirect_to '/statics/shop/payment/result/success.html'
      end
    else
      if params[:source] == 'notify'
        render :text => "failure", :layout => false
      else
        redirect_to '/statics/shop/payment/result/failure.html'
      end
    end
  end

  def cmbc_return # :nodoc:
    @trade = Shop::Trade.acquire(params[:id])

    result = CMBC::JnkyServer.decrypt_data(PAYMENT_CONFIG['cmbc']['public_key'], PAYMENT_CONFIG['cmbc']['private_key'], params["payresult"])
    options = "order_id|merchant_id|order_price|tx_date|tx_time|status|remark1|remark2".split('|').map(&:to_sym).each_with_index.map { |key, i| {key => result.split('|')[i]} }.inject(&:merge)

    unless options[:status] == "0" && options[:order_id] == PAYMENT_CONFIG['cmbc']['merchantId'] + @trade.id.to_s.rjust(15, '0') && options[:order_price].to_i == @trade.payment_price
      redirect_to '/statics/shop/payment/result/failure.html'
      return
    end

    @success = database_transaction do
      @trade.audit!(:payment_service => 'cmbc')
    end

    if @success
      redirect_to '/statics/shop/payment/result/success.html'
    else
      redirect_to '/statics/shop/payment/result/failure.html'
    end
  end

  def pab_return # :nodoc:
    @trade = Shop::Trade.acquire(params[:id])

    if @trade.status != 'pay'
      if params[:source] == 'notify'
        render :text => "http://#{HOSTS['dynamic']}/shop/trades/#{@trade.id}/pab_return", :layout => false
      else
        redirect_to '/statics/shop/payment/result/success.html'
      end
      return
    end

    unless params[:PayFlag] == "1" && params[:PayAmount].to_f == @trade.payment_price && OpenSSL::PKey::RSA.new(PAYMENT_CONFIG['pab']['public_key']).verify(OpenSSL::Digest::SHA1.new, Base64.decode64(params[:Signature]), %W(OrderNo PayAmount Currency PayFlag TranTime).map { |field| "#{field}=#{params[field]}" }.join('&'))
      redirect_to '/statics/shop/payment/result/failure.html'
      return
    end

    @success = database_transaction do
      @trade.audit!(:payment_service => 'pab')
    end

    if @success
      if params[:source] == 'notify'
        render :text => "http://#{HOSTS['dynamic']}/shop/trades/#{@trade.id}/pab_return", :layout => false
      else
        redirect_to '/statics/shop/payment/result/success.html'
      end
    else
      if params[:source] == 'notify'
        render :text => "failure", :layout => false
      else
        redirect_to '/statics/shop/payment/result/failure.html'
      end
    end
  end

  def pab_pay_return # :nodoc:
    @trade = Shop::Trade.acquire(params[:id])

    if @trade.status != 'pay'
      redirect_to '/statics/shop/payment/result/success.html'
      return
    end
    options = %W(version charset notifyId notifyType notifyTime merchantId mercOrderNo orderTraceNo orderStatus orderCreateTime orderPayTime backEndUrl frontEndUrl orderTime orderAmount orderCurrency businessScene resCode resMessage).sort.map { |field| "#{field}=#{params[field]}" }.join('&')
    unless params[:orderStatus] == "00" && params[:orderAmount].to_f == @trade.payment_price*100 && params[:merchantId] == PAYMENT_CONFIG['pab_pay']['merchantId'] && OpenSSL::Digest::SHA256.hexdigest(options+PAYMENT_CONFIG['pab_pay']['key']) == params[:signature]
      redirect_to '/statics/shop/payment/result/failure.html'
      return
    end

    @success = database_transaction do
      @trade.audit!(:payment_service => 'pab_pay')
    end

    if @success
      redirect_to '/statics/shop/payment/result/success.html'
    else
      redirect_to '/statics/shop/payment/result/failure.html'
    end
  end

  def pgs_return # :nodoc:
    @trade = Shop::Trade.acquire(params[:id])

    if @trade.status != 'pay'
      if params[:source] == 'notify'
        render :text => "OUTTRADENO_#{@trade.id}", :layout => false
      else
        redirect_to '/statics/shop/payment/result/success.html'
      end
      return
    end

    options = %W(inputCharset version service_name notify_time signType partner seller_email seller_mobile subject quantity detail bank_id trade_status error_code trade_no out_trade_no amount fee payment_type payment_time ext1 ext2).sort.map { |field| "#{field}=#{params[field]}" }.join('&')
    sign = Digest::MD5.hexdigest(options+PAYMENT_CONFIG['pgs']['signNo'])

    unless params[:trade_status] == "00" && params[:amount].to_i == @trade.payment_price && params[:partner] == PAYMENT_CONFIG['pgs']['merchantId'] && params[:out_trade_no] == @trade.id.to_s && params[:sign] == sign
      redirect_to '/statics/shop/payment/result/failure.html'
      return
    end

    @success = database_transaction do
      @trade.audit!(:payment_service => 'pgs')
    end

    if @success
      if params[:source] == 'notify'
        render :text => "OUTTRADENO_#{@trade.id}", :layout => false
      else
        redirect_to '/statics/shop/payment/result/success.html'
      end
    else
      if params[:source] == 'notify'
        render :text => "failure", :layout => false
      else
        redirect_to '/statics/shop/payment/result/failure.html'
      end
    end
  end

  def yeepay_return # :nodoc:
    @trade = Shop::Trade.acquire(params[:id])
    if @trade.status != 'pay'
      render text: "SUCCESS_#{@trade.id}", layout: false and return if params[:r9_btype].to_i==2
      redirect_to "/statics/shop/payment/result/success.html" and return
    end
    values = %W(p1_MerId r0_Cmd r1_Code r2_TrxId r3_Amt r4_Cur r5_Pid r6_Order r7_Uid r8_MP r9_BType).inject([]) { |array, field| array << params[field]; array }
    hmac = HMAC::MD5.new(PAYMENT_CONFIG['yeepay']['securityKey']).update(values.join).to_s
    redirect_to '/statics/shop/payment/result/failure.html' and return unless params[:r1_Code].to_i == 1 && params[:r3_Amt].to_i == @trade.payment_price.to_i && params[:p1_MerId] == PAYMENT_CONFIG['yeepay']['merId'].to_s && params[:r6_Order].to_s == @trade.id.to_s && params[:hmac].to_s == hmac
    @success = database_transaction do
      @trade.audit!(:payment_service => "yeepay", :payment_identifier => params[:r2_TrxId])
    end
    render text: @success ? "SUCCESS_#{@trade.id}" : "failure", layout: false and return if params[:r9_btype].to_i==2
    redirect_to "/statics/shop/payment/result/#{@success ? "success" : "failure"}.html"
  end

  def boc_creditcard_return # :nodoc:
    @trade = Shop::Trade.acquire(params[:id])

    if @trade.status != 'pay'
      redirect_to '/statics/shop/payment/result/success.html'
      return
    end

    result = Nokogiri::XML::Document.parse(params[:reqData]).css("result").first
    orig = result.css('orig').first
    cert = OpenSSL::X509::Certificate.new(PAYMENT_CONFIG['boc_creditcard']['public_key']) rescue nil
    is_valid = cert && OpenSSL::PKCS7.new(Base64.decode64(result.css('sign').text)).verify([cert], OpenSSL::X509::Store.new, (%w[status serialno masterid orderid date authCode instalFirstAmt instalmentFee everyPayAmt tranAmount retrReferenceNum].map { |k| orig.css(k).text }).join('|').encode('iso-8859-01', 'utf-8'), OpenSSL::PKCS7::NOVERIFY)

    unless orig.css("status").text == '0' && orig.css("serialno").text == PAYMENT_CONFIG['boc_creditcard']['serialNo'] && orig.css("masterid").text == PAYMENT_CONFIG['boc_creditcard']['masterId'] && orig.css("orderid").text.to_i == @trade.id && orig.css("tranAmount").text.to_i == @trade.payment_price*100 && is_valid
      redirect_to '/statics/shop/payment/result/failure.html'
      return
    end

    @success = database_transaction do
      @trade.audit!(:payment_service => 'boc_creditcard')
    end

    if @success
      redirect_to '/statics/shop/payment/result/success.html'
    else
      redirect_to '/statics/shop/payment/result/failure.html'
    end
  end

  def boc_return # :nodoc:
    @trade = Shop::Trade.acquire(params[:id])

    if @trade.status != 'pay'
      redirect_to '/statics/shop/payment/result/success.html'
      return
    end

    cert = OpenSSL::X509::Certificate.new(PAYMENT_CONFIG['boc']['public_key']) rescue nil
    is_valid = cert && OpenSSL::PKCS7.new(Base64.decode64(params["signData"])).verify([cert], OpenSSL::X509::Store.new, "merchantNo|orderNo|orderSeq|cardTyp|payTime|orderStatus|payAmount".split('|').map(&:to_sym).map { |option| params[option] }.join("|").encode('iso-8859-1', 'utf-8'), OpenSSL::PKCS7::NOVERIFY)

    unless params[:merchantNo] == PAYMENT_CONFIG['boc']['merchantNo'] && params[:orderNo].to_i == @trade.id && params[:payAmount].to_i == @trade.payment_price && params[:orderStatus] == '1' && is_valid
      redirect_to '/statics/shop/payment/result/failure.html'
      return
    end

    @success = database_transaction do
      @trade.audit!(:payment_service => 'boc')
    end

    if @success
      redirect_to '/statics/shop/payment/result/success.html'
    else
      redirect_to '/statics/shop/payment/result/failure.html'
    end
  end

  def comm_creditcard_return # :nodoc:
    @trade = Shop::Trade.acquire(params[:orderId])

    xml = COMM::SecurityMessageCrypto.OpenSecurityMessage(params[:transDataXml], "#{RAILS_ROOT}/config/comm.cer", "#{RAILS_ROOT}/config/comm.pfx", PAYMENT_CONFIG['comm_creditcard']['password'])
    result = Nokogiri::XML::Document.parse(xml).css("shopOrderService/orderData")
    unless result.css("returnCode").text == "00" && result.attr("id").text.to_i == @trade.id && result.css("merchant").attr('id').text == PAYMENT_CONFIG['comm_creditcard']['merchantId'] && result.css("totalAmount").text.to_i == @trade.payment_price*100
      redirect_to payment_failure_shop_trades_path
      return
    end

    @success = database_transaction do
      @trade.audit!(:payment_service => 'comm_creditcard', :payment_identifier => result.attr('shopTraceNo').text)
    end

    if @success
      redirect_to payment_success_shop_trades_path
    else
      redirect_to payment_failure_shop_trades_path
    end
  end

  def wechat_return # :nodoc:
    @trade = Shop::Trade.acquire(params[:id])
    payment_return_data=Hash.from_xml(request.raw_post)["xml"]
    respond_to do |format|
      unless payment_return_data["result_code"] == 'SUCCESS' && payment_return_data["total_fee"].to_s == (@trade.payment_price*100).to_s && payment_return_data.try(:[], "openid").present?
        # && Digest::MD5.hexdigest(payment_return_data.except("sign").reject { |k, v| v.blank? }.sort.map { |k, v| "#{k.to_s}=#{v.to_s}" }.push("key=#{PAYMENT_CONFIG['wechat']['paySignKey']}").join('&')).upcase == payment_return_data["sign"].to_s
        format.xml { render xml: "<xml><return_code><![CDATA[FAIL]]></return_code><return_msg><![CDATA[ERROR]]></return_msg></xml>", layout => false, :content_type => Mime::XML }
        return
      end

      @success = database_transaction do
        if @trade.status != 'pay' && @trade.payment_service == 'wechat'
          @trade.update_attributes!(payment_return: payment_return_data.to_json)
        else
          @trade.audit!(payment_service: 'wechat', payment_identifier: payment_return_data["transaction_id"], payment_return: payment_return_data.to_json)
        end
      end

      if @success
        format.xml { render xml: "<xml><return_code><![CDATA[SUCCESS]]></return_code><return_msg><![CDATA[OK]]></return_msg></xml>", layout => false, :content_type => Mime::XML }
      else
        format.xml { render xml: "<xml><return_code><![CDATA[FAIL]]></return_code><return_msg><![CDATA[ERROR]]></return_msg></xml>", layout => false, :content_type => Mime::XML }
      end
    end
  end

  def icbc_return # :nodoc:
    @trade = Shop::Trade.acquire(params[:id])

    if @trade.status != 'pay'
      redirect_to '/statics/shop/payment/result/success.html'
      return
    end

    unless OpenSSL::X509::Certificate.new(PAYMENT_CONFIG['icbc']['public_key']).public_key.public_encrypt(params[:signMsg]) == Digest::SHA1.digest(Base64.decode64(params[:notifyData]))
      redirect_to '/statics/shop/payment/result/failure.html'
      return
    end

    @success = database_transaction do
      @trade.audit!(payment_service: 'icbc')
    end

    if @success
      redirect_to '/statics/shop/payment/result/success.html'
    else
      redirect_to '/statics/shop/payment/result/failure.html'
    end
  end

  ##
  # == 查询快钱
  #
  # === Request
  #
  # ==== Resource
  #
  # PUT /shop/trades/:id/bill99_query
  #
  # ==== Parameters
  #
  # id :: 交易ID
  # \trade[checkout_token] : 付款令牌(他人代付时生效)
  #
  # === Response
  #
  # 返回一条Shop::Shop::Trade
  #
  def bill99_query
    @trade = Shop::Trade.acquire(params[:id])

    database_transaction do
      @trade.query_bill99!
    end

    respond_to do |format|
      format.html { redirect_to params[:redirect] || shop_trade_path(@trade) }
      format.xml { @data = {'trade' => @current_user && @trade.user_id == @current_user.id ? @trade : @trade.assign_options(Shop::Trade.others_to_pay_xml_options)} }
    end
  end

  ##
  # == 查询支付宝
  #
  # === Request
  #
  # ==== Resource
  #
  # PUT /shop/trades/:id/alipay_query
  #
  # ==== Parameters
  #
  # id :: 交易ID
  # \trade[checkout_token] : 付款令牌(他人代付时生效)
  #
  # === Response
  #
  # 返回一条Shop::Shop::Trade
  #
  def alipay_query
    @trade = Shop::Trade.acquire(params[:id])

    database_transaction do
      @trade.query_alipay!
    end

    respond_to do |format|
      format.html { redirect_to params[:redirect] || shop_trade_path(@trade) }
      format.xml { @data = {'trade' => @current_user && @trade.user_id == @current_user.id ? @trade : @trade.assign_options(Shop::Trade.others_to_pay_xml_options)} }
    end
  end

  ##
  # == 查询招商银行
  #
  # === Request
  #
  # ==== Resource
  #
  # PUT /shop/trades/:id/cmbchina_query
  #
  # ==== Parameters
  #
  # id :: 交易ID
  # \trade[checkout_token] : 付款令牌(他人代付时生效)
  #
  # === Response
  #
  # 返回一条Shop::Shop::Trade
  #
  def cmbchina_query
    @trade = Shop::Trade.acquire(params[:id])

    database_transaction do
      @trade.query_cmbchina!
    end

    respond_to do |format|
      format.html { redirect_to params[:redirect] || shop_trade_path(@trade) }
      format.xml { @data = {'trade' => @current_user && @trade.user_id == @current_user.id ? @trade : @trade.assign_options(Shop::Trade.others_to_pay_xml_options)} }
    end
  end

  ##
  # == 查询招商银行信用卡
  #
  # === Request
  #
  # ==== Resource
  #
  # PUT /shop/trades/:id/cmbchina_creditcard_query
  #
  # ==== Parameters
  #
  # id :: 交易ID
  # \trade[checkout_token] : 付款令牌(他人代付时生效)
  #
  # === Response
  #
  # 返回一条Shop::Shop::Trade
  #
  def cmbchina_creditcard_query
    @trade = Shop::Trade.acquire(params[:id])

    database_transaction do
      @trade.query_cmbchina_creditcard!
    end

    respond_to do |format|
      format.html { redirect_to params[:redirect] || shop_trade_path(@trade) }
      format.xml { @data = {'trade' => @current_user && @trade.user_id == @current_user.id ? @trade : @trade.assign_options(Shop::Trade.others_to_pay_xml_options)} }
    end
  end

  ##
  # == 查询拉卡拉
  #
  # === Request
  #
  # ==== Resource
  #
  # PUT /shop/trades/:id/lakala_query
  #
  # ==== Parameters
  #
  # id :: 交易ID
  # \trade[checkout_token] : 付款令牌(他人代付时生效)
  #
  # === Response
  #
  # 返回一条Shop::Shop::Trade
  #
  def lakala_query
    @trade = Shop::Trade.acquire(params[:id])

    database_transaction do
      @trade.query_lakala!
    end

    respond_to do |format|
      format.html { redirect_to params[:redirect] || shop_trade_path(@trade) }
      format.xml { @data = {'trade' => @current_user && @trade.user_id == @current_user.id ? @trade : @trade.assign_options(Shop::Trade.others_to_pay_xml_options)} }
    end
  end

  ##
  # == 查询建设银行
  #
  # === Request
  #
  # ==== Resource
  #
  # PUT /shop/trades/:id/ccb_query
  #
  # ==== Parameters
  #
  # id :: 交易ID
  # \trade[checkout_token] : 付款令牌(他人代付时生效)
  #
  # === Response
  #
  # 返回一条Shop::Shop::Trade
  #
  def ccb_query
    @trade = Shop::Trade.acquire(params[:id])

    database_transaction do
      @trade.query_ccb!
    end

    respond_to do |format|
      format.html { redirect_to params[:redirect] || shop_trade_path(@trade) }
      format.xml { @data = {'trade' => @current_user && @trade.user_id == @current_user.id ? @trade : @trade.assign_options(Shop::Trade.others_to_pay_xml_options)} }
    end
  end

  ##
  # == 查询中国银联
  #
  # === Request
  #
  # ==== Resource
  #
  # PUT /shop/trades/:id/unionpay_query
  #
  # ==== Parameters
  #
  # id :: 交易ID
  # \trade[checkout_token] : 付款令牌(他人代付时生效)
  #
  # === Response
  #
  # 返回一条Shop::Shop::Trade
  #
  def unionpay_query
    @trade = Shop::Trade.acquire(params[:id])

    database_transaction do
      @trade.query_unionpay!
    end

    respond_to do |format|
      format.html { redirect_to params[:redirect] || shop_trade_path(@trade) }
      format.xml { @data = {'trade' => @current_user && @trade.user_id == @current_user.id ? @trade : @trade.assign_options(Shop::Trade.others_to_pay_xml_options)} }
    end
  end

  ##
  # == 查询中国银联移动支付
  #
  # === Request
  #
  # ==== Resource
  #
  # PUT /shop/trades/:id/unionpay_wap_query
  #
  # ==== Parameters
  #
  # id :: 交易ID
  #
  # === Response
  #
  # 返回一条Shop::Shop::Trade
  #
  def unionpay_wap_query
    @trade = Shop::Trade.acquire(params[:id])

    database_transaction do
      @trade.query_unionpay_wap!
    end

    respond_to do |format|
      format.html { redirect_to params[:redirect] || shop_trade_path(@trade) }
      format.xml { @data = {'trade' => @trade} }
    end
  end

  ##
  # == 查询民生银行
  #
  # === Request
  #
  # ==== Resource
  #
  # PUT /shop/trades/:id/cmbc_query
  #
  # ==== Parameters
  #
  # id :: 交易ID
  # \trade[checkout_token] : 付款令牌(他人代付时生效)
  #
  # === Response
  #
  # 返回一条Shop::Shop::Trade
  #
  def cmbc_query
    @trade = Shop::Trade.acquire(params[:id])

    database_transaction do
      @trade.query_cmbc!
    end

    respond_to do |format|
      format.html { redirect_to params[:redirect] || shop_trade_path(@trade) }
      format.xml { @data = {'trade' => @current_user && @trade.user_id == @current_user.id ? @trade : @trade.assign_options(Shop::Trade.others_to_pay_xml_options)} }
    end
  end

  ##
  # == 查询平安银行
  #
  # === Request
  #
  # ==== Resource
  #
  # PUT /shop/trades/:id/pab_query
  #
  # ==== Parameters
  #
  # id :: 交易ID
  # \trade[checkout_token] : 付款令牌(他人代付时生效)
  #
  # === Response
  #
  # 返回一条Shop::Shop::Trade
  #
  def pab_query
    @trade = Shop::Trade.acquire(params[:id])

    database_transaction do
      @trade.query_pab!
    end

    respond_to do |format|
      format.html { redirect_to params[:redirect] || shop_trade_path(@trade) }
      format.xml { @data = {'trade' => @current_user && @trade.user_id == @current_user.id ? @trade : @trade.assign_options(Shop::Trade.others_to_pay_xml_options)} }
    end
  end

  ##
  # == 查询平安付
  #
  # === Request
  #
  # ==== Resource
  #
  # PUT /shop/trades/:id/pab_pay_query
  #
  # ==== Parameters
  #
  # id :: 交易ID
  # \trade[checkout_token] : 付款令牌(他人代付时生效)
  #
  # === Response
  #
  # 返回一条Shop::Shop::Trade
  #
  def pab_pay_query
    @trade = Shop::Trade.acquire(params[:id])

    database_transaction do
      @trade.query_pab_pay!
    end

    respond_to do |format|
      format.html { redirect_to params[:redirect] || shop_trade_path(@trade) }
      format.xml { @data = {'trade' => @current_user && @trade.user_id == @current_user.id ? @trade : @trade.assign_options(Shop::Trade.others_to_pay_xml_options)} }
    end
  end

  ##
  # == 查询海航易支付
  #
  # === Request
  #
  # ==== Resource
  #
  # PUT /shop/trades/:id/pgs_query
  #
  # ==== Parameters
  #
  # id :: 交易ID
  #
  # == Response
  #
  # 返回一条Shop::Shop::Trade
  #
  def pgs_query
    @trade = Shop::Trade.acquire(params[:id])

    database_transaction do
      @trade.query_pgs!
    end

    respond_to do |format|
      format.html { redirect_to params[:redirect] || shop_trade_path(@trade) }
      format.xml { @data = {'trade' => @current_user && @trade.user_id == @current_user.id ? @trade : @trade.assign_options(Shop::Trade.others_to_pay_xml_options)} }
    end
  end

  ##
  # == 查询易宝支付
  #
  # === Request
  #
  # ==== Resource
  #
  # PUT /shop/trades/:id/yeepay_query
  #
  # ==== Parameters
  #
  # id :: 交易ID
  #
  # == Response
  #
  # 返回一条Shop::Shop::Trade
  #
  def yeepay_query
    @trade = Shop::Trade.acquire params[:id]
    database_transaction do
      @trade.query_yeepay!
    end
    respond_to do |format|
      format.html { redirect_to params[:redirect] || shop_trade_path(@trade) }
      format.xml { @data = {'trade' => @current_user && @trade.user_id == @current_user.id ? @trade : @trade.assign_options(Shop::Trade.others_to_pay_xml_options)} }
    end
  end

  ##
  # == 查询中国银行快捷支付
  #
  # === Request
  #
  # ==== Resource
  #
  # PUT /shop/trades/:id/boc_creditcard_query
  #
  # ==== Parameters
  #
  # id :: 交易ID
  #
  # == Response
  #
  # 返回一条Shop::Shop::Trade
  #
  def boc_creditcard_query
    @trade = Shop::Trade.acquire(params[:id])

    database_transaction do
      @trade.query_boc_creditcard!
    end

    respond_to do |format|
      format.html { redirect_to params[:redirect] || shop_trade_path(@trade) }
      format.xml { @data = {'trade' => @current_user && @trade.user_id == @current_user.id ? @trade : @trade.assign_options(Shop::Trade.others_to_pay_xml_options)} }
    end
  end

  ##
  # == 查询中国银行
  #
  # === Request
  #
  # ==== Resource
  #
  # PUT /shop/trades/:id/boc_query
  #
  # ==== Parameters
  #
  # id :: 交易ID
  #
  # == Response
  #
  # 返回一条Shop::Shop::Trade
  #
  def boc_query
    @trade = Shop::Trade.acquire(params[:id])

    database_transaction do
      @trade.query_boc!
    end

    respond_to do |format|
      format.html { redirect_to params[:redirect] || shop_trade_path(@trade) }
      format.xml { @data = {'trade' => @current_user && @trade.user_id == @current_user.id ? @trade : @trade.assign_options(Shop::Trade.others_to_pay_xml_options)} }
    end
  end

  ##
  # == 查询交通快捷支付
  #
  # === Request
  #
  # ==== Resource
  #
  # PUT /shop/trades/:id/comm_creditcard_query
  #
  # ==== Parameters
  #
  # id :: 交易ID
  #
  # == Response
  #
  # 返回一条Shop::Shop::Trade
  #
  def comm_creditcard_query
    @trade = Shop::Trade.acquire(params[:id])

    database_transaction do
      @trade.query_comm_creditcard!
    end

    respond_to do |format|
      format.html { redirect_to params[:redirect] || shop_trade_path(@trade) }
      format.xml { @data = {'trade' => @current_user && @trade.user_id == @current_user.id ? @trade : @trade.assign_options(Shop::Trade.others_to_pay_xml_options)} }
    end
  end

  ##
  # == 查询微信支付
  #
  # === Request
  #
  # ==== Resource
  #
  # PUT /shop/trades/:id/wechat_query
  #
  # ==== Parameters
  #
  # id :: 交易ID
  #
  # == Response
  #
  # 返回一条Shop::Shop::Trade
  #
  def wechat_query
    @trade = Shop::Trade.acquire(params[:id])

    database_transaction do
      @trade.query_wechat!
    end

    respond_to do |format|
      format.html { redirect_to params[:redirect] || shop_trade_path(@trade) }
      format.xml { @data = {'trade' => @current_user && @trade.user_id == @current_user.id ? @trade : @trade.assign_options(Shop::Trade.others_to_pay_xml_options)} }
    end
  end

  # == Function
  #
  # 查询中国工商银行支付是否完成付款
  #
  # == Route
  #
  # PUT /shop/trades/:id/icbc_query
  #
  # == Parameters
  #
  # id :: 交易ID
  #
  # == Response
  #
  # 返回一条Shop::Shop::Trade
  #
  def icbc_query
    @trade = Shop::Trade.acquire(params[:id])

    database_transaction do
      @trade.query_icbc!
    end

    respond_to do |format|
      format.html { redirect_to params[:redirect] || shop_trade_path(@trade) }
      format.xml { @data = {'trade' => @current_user && @trade.user_id == @current_user.id ? @trade : @trade.assign_options(Shop::Trade.others_to_pay_xml_options)} }
    end
  end

  ##
  # == 确认收货
  #
  # === Request
  #
  # ==== Resource
  #
  # PUT /shop/trades/:id/receive
  #
  # ==== Parameters
  #
  # id :: 交易ID
  # \trade[checkout_token] : 付款令牌(他人代付时生效)
  #
  # === Response
  #
  # 返回一条Shop::Shop::Trade
  #
  def receive
    @trade = Shop::Trade.acquire(params[:id])

    if @trade.user_id != @current_user.id || @trade.status != 'receive'
      not_authorized
      return
    end

    @success = database_transaction do
      @trade.update_attributes!(:status => 'complete')
      # @trade.updated!(:status => @trade.status)
    end

    if @success
      respond_to do |format|
        format.html { redirect_to params[:redirect] || shop_trade_path(@trade) }
        format.js { render :text => "" }
        format.xml { @data = {'trade' => @trade} }
      end
    else
      respond_to do |format|
        format.html { redirect_to params[:redirect] || shop_trade_path(@trade) }
        format.js { raise }
        format.xml { ActiveRecord::RecordInvalid.new(@note) }
      end
    end
  end

  ##
  # == 取消交易
  #
  # === Request
  #
  # ==== Resource
  #
  # PUT /shop/trades/:id/cancel
  #
  # ==== Parameters
  #
  # id :: 交易ID
  #
  # === Response
  #
  # 返回一条Shop::Shop::Trade
  #
  def cancel
    @trade = Shop::Trade.acquire(params[:id])

    if @trade.user_id != @current_user.id || @trade.status != 'pay'
      not_authorized
      return
    end

    @success = database_transaction do
      @trade.update_attributes!(:status => 'cancel')
      # @trade.updated!(:status => @trade.status)
      # @trade.ticket.update_attributes!(:trade_id => nil, :user_id => nil) if @trade.ticket
      @trade.units.each(&:returnit!)
      @trade.calculate_product_hourglass!
      @trade.close_payment
    end

    respond_to do |format|
      if @success
        format.html { redirect_to params[:redirect] || shop_trade_path(@trade) }
        format.xml { @data = {'trade' => @trade} }
        format.js { render :text => "" }
      else
        format.html { redirect_to request.referer || shop_trade_path(@trade) }
        format.xml { raise ActiveRecord::RecordInvalid.new(@trade||Shop::Trade.new) }
        format.js { raise }
      end
    end
  end

  ##
  # == 添加到购物车
  #
  # === Request
  #
  # ==== Resource
  #
  # POST /shop/trades/add_to_cart
  #
  # ==== Parameters
  #
  # \units[][product_id] :: 产品ID
  # \units[][measure] :: 尺寸
  # \units[][percent] :: 折扣
  #
  # === Response
  #
  # ==== XML
  #
  #   <response>
  #     <units type="Array">
  #       <unit type="Shop::Unit">
  #         <product_id type="integer">产品ID</product_id>
  #         <measure>尺寸</measure>
  #         <percent>折扣</percent>
  #         <quantity>折扣</数量>
  #       </unit>
  #     </units>
  #   </response>
  #
  # ==== JSON
  #
  #   {
  #     units : [
  #       {
  #         'product_id' : 产品ID,
  #         'measure' : 尺寸,
  #         'percent' : 折扣,
  #         'quantity' : 数量,
  #       },
  #     ],
  #   }
  #
  def add_to_cart
    units = params[:units]
    units = units.values if units.is_a?(Hash)
    units = units.map { |u| u.slice(*%w[product_id measure percent quantity]) }
    @cart = ActiveSupport::JSON.decode((@current_user ? @current_user.cart_data : session[:cart_data]) || '[]') rescue []
    @cart ||= []
    units.each { |unit| @cart << unit unless @cart.find { |u| u['product_id'] == unit['product_id'] && u['measure'] == unit['measure'] } }

    if @current_user
      @current_user.update_attributes(:cart_data => @cart.to_json)
    else
      session[:cart_data] = @cart.to_json
    end

    respond_to do |format|
      format.html { redirect_to params[:redirect] || new_shop_trade_path }
      format.xml { render :json => {'units' => @cart.map { |u| Shop::Unit.new(u) }.assign_options(:only => [:percent], :methods => [:product_id, :measure, :quantity])} }
    end
  end

  ##
  # == 更新购物车
  #
  # === Request
  #
  # ==== Resource
  #
  # POST /shop/trades/update_cart
  #
  # ==== Parameters
  #
  # \units[][product_id] :: 产品ID
  # \units[][measure] :: 尺寸
  # \units[][percent] :: 折扣
  # \units[][quantity] :: 数量
  # units :: 不传即为清空
  #
  # === Response
  #
  # ==== JSON
  #
  #   {
  #     units : [
  #       {
  #         'product_id' : 产品ID,
  #         'measure' : 尺寸,
  #         'percent' : 折扣,
  #       },
  #     ],
  #   }
  #
  def update_cart
    units = params[:units] || []
    units = units.sort_by { |k, v| k.to_i }.map { |k, v| v } if units.is_a?(Hash)
    units = units.map { |u| u.slice(*%w[product_id measure percent quantity]) }
    @cart = units

    if @current_user
      @current_user.update_attributes(:cart_data => @cart.to_json)
    else
      session[:cart_data] = @cart.to_json
    end

    respond_to do |format|
      format.html { redirect_to params[:redirect] || new_shop_trade_path }
      format.js { render :text => "" }
      format.xml { @data = {'units' => @cart.map { |u| Unit.new(u) }.assign_options(:only => [:percent], :methods => [:product_id, :measure, :quantity])} }
    end
  end

  ##
  # == 查询联邦快递状态
  #
  # === Request
  #
  # ==== Resource
  #
  # GET /shop/trades/:id/fedex_query
  #
  # ==== Parameters
  #
  # id :: 交易ID
  #
  # === Response
  #
  # （参考联邦快递文档）
  #
  def fedex_query
    @trade = Shop::Trade.acquire(params[:id])
    xml = @trade.fedex_result

    respond_to do |format|
      format.xml { render :text => xml }
    end
  end

  ##
  # == 查询宅急送快递状态
  #
  # === Request
  #
  # ==== Resource
  #
  # GET /shop/trades/:id/zjs_query
  #
  # ==== Parameters
  #
  # id :: 交易ID
  #
  # === Response
  #
  # （参考宅急送文档）
  #
  def zjs_query
    @trade = Shop::Trade.acquire(params[:id])
    @xml = @trade.zjs_result
    respond_to do |format|
      format.xml { render :text => @xml }
    end
  end

  ##
  # == 查询顺丰速运状态
  #
  # === Request
  #
  # ==== Resource
  #
  # GET /shop/trades/:id/sf_query
  #
  # ==== Parameters
  #
  # id :: 交易ID
  #
  # === Response
  #
  # （参考顺丰文档）
  #
  def sf_query
    @trade = Shop::Trade.acquire(params[:id])
    if @trade.user_id != @current_user.id
      not_authorized
      return
    end

    @xml = @trade.sf_result
    respond_to do |format|
      format.xml { render :text => @xml }
    end
  end

  ##
  # == 通用查询快递状态
  #
  # === Request
  #
  # ==== Resource
  #
  # GET /shop/trades/:id/delivery_query
  #
  # ==== Parameters
  #
  # id :: 交易ID
  #
  # === Response
  #
  # ==== JSON
  #
  #   {
  #     steps : [
  #       {
  #         'time' : 时间,
  #         'address' : 地点,
  #         'action' : 状态,
  #       },
  #     ]
  #   }
  #
  def delivery_query
    @trade = Shop::Trade.acquire(params[:id])
    if @trade.user_id != @current_user.id
      not_authorized
      return
    end

    respond_to do |format|
      format.xml { @data = {'steps' => @trade.trade_delivery_result[:steps]} }
    end
  end

  ##
  # == 通用查询发票快递状态
  #
  # === Request
  #
  # ==== Resource
  #
  # GET /shop/trades/:id/invoice_delivery_query
  #
  # ==== Parameters
  #
  # id :: 交易ID
  #
  # === Response
  #
  # ==== JSON
  #
  #   {
  #     steps : [
  #       {
  #         'time' : 时间,
  #         'address' : 地点,
  #         'action' : 状态,
  #       },
  #     ]
  #   }
  #
  def invoice_delivery_query
    @trade = Shop::Trade.acquire(params[:id])
    if @trade.user_id != @current_user.id
      not_authorized
      return
    end

    respond_to do |format|
      format.xml { @data = {'steps' => @trade.invoice_delivery_result[:steps]} }
    end
  end

  ##
  # == 360CPS系统查询订单
  #
  # === Request
  #
  # ==== Resource
  #
  # POST /shop/trades/mall360
  #
  # ==== Parameters
  #
  # bid :: 合作网站编号
  # order_ids :: 多个订单号,中间用逗号(,)分隔
  # start_time :: 按下单时间查询，起始时间
  # end_time :: 按下单时间查询，结束时间
  # updstart_time :: 按订单最后更新时间查询，起始时间
  # updend_time :: 按订单最后更新时间查询，结束时间
  # last_order_id :: 上次查询返回的最后一个订单号
  # active_time :: 调用发起时间，精确到秒
  # sign :: 签名信息
  #
  # === Response
  #
  # ==== XML
  #   <orders>
  #     <order>
  #       <status>订单状态</status>
  #       <qihoo_id>360业务编号</qihoo_id>
  #       <order_time>下单时间</order_time>
  #       <server_price>服务费用</server_price>
  #       <order_updtime>订单最后更新时间</order_updtime>
  #       <total_price>订单应付总额</total_price>
  #       <total_comm>总佣金</total_comm>
  #       <ext>扩展字段，必须回传跳转接口中传递过来的值</ext>
  #       <coupon>用户使用优惠卡或积分抵充商品的金额</coupon>
  #       <qid>360用户ID</qid>
  #       <commission>佣金明细 商品分类id,分成比例,分成金额,商品单价,数量|商品分类id,分成比例,分成金额,商品单价,数量|优惠券扣除佣金额</commission>
  #       <order_id>订单号</order_id>
  #       <bid>合作网站编号</bid>
  #       <p_info>订单商品的详细信息 商品分类id,商品名称,商品编号,商品单价,商品数量,商品一级分类名称_二级分类名称_商品当前分类名称,商品url|商品分类id,商品名称,商品编号,商品单价,商品数量,商品一级分类名称_二级分类名称_商品当前分类名称,商品url</p_info>
  #     </order>
  #   </orders>
  #
  def mall360
    config = OAUTH_CONFIG["mall360"]

    unless params[:sign] == Digest::MD5.hexdigest("#{params[:bid]}##{params[:active_time]}##{config["secret"]}")
      render :text => "签名验证失败", :layout => false
      return
    end

    conditions = [
      !params[:end_time].blank? && ["shop_trades.created_at < ?", params[:end_time]],
      !params[:start_time].blank? && ["shop_trades.created_at >= ?", params[:start_time]],
      !params[:updstart_time].blank? && ["shop_trades.updated_at >= ?", params[:updstart_time]],
      !params[:updend_time].blank? && ["shop_trades.updated_at < ?", params[:updend_time]],
      !params[:order_ids].blank? && ["shop_trades.id IN (?)", params[:order_ids].split(',').map(&:to_i)],
      !params[:last_order_id].blank? && ["shop_trades.id > ?", params[:last_order_id]],
    ].reject! { |condition| condition == false }

    @trades = Shop::Trade.limit(200).where([conditions.to_a.transpose.first.to_a.push("shop_trades.link_id IN (SELECT id FROM shop_links WHERE ad_id IN (SELECT id FROM shop_ads WHERE promotion_id = 132)) AND shop_clicks.id IS NOT NULL").map { |condition| "(#{condition})" }.join(' AND ')].concat(conditions.to_a.transpose.last.to_a)).order("id ASC").joins("left join shop_clicks on shop_trades.click_id = shop_clicks.id AND shop_clicks.path REGEXP 'qihoo_id'").select("shop_trades.*, shop_clicks.path")
    @trades.map! do |trade|
      is_first_trade = trade == trade.user.trades.scoped(:conditions => "ship_at IS NOT NULL", :order => "created_at ASC").first
      sharing_options = trade.link_id == 300173 ? {'ratio' => 0.40, 'description' => '40%'} : {'ratio' => 0.10, 'description' => '10%'}
      cps_option = URI.decode(URI.parse(trade.click.path).query).scan(/([^=;&]+)=([^;&]*)/).map { |k, v| {k => v} }.inject({}, &:merge).symbolize_keys.slice(:qihoo_id, :qid, :ext) rescue {}

      {
        :bid => config["key"],
        :qid => cps_option[:qid] || 0,
        :qihoo_id => cps_option[:qihoo_id] || 0,
        :ext => cps_option[:ext] || '',
        :order_id => trade.id,
        :order_time => trade.created_at && trade.created_at.to_s(:db),
        :order_updtime => trade.updated_at && trade.updated_at.to_s(:db),
        :total_comm => trade.units && "%.2f" % (is_first_trade && 500 || (trade.units.map(&:price).sum * sharing_options['ratio'])),
        :commission => trade.units && (is_first_trade && (trade.units.each_with_index.map { |unit, index| "#{unit.item.product.category2.id rescue 0},#{ index == 0 ? "F500,500.00," : "0%,0.00,"}#{"%.2f" % unit.discount},1" }).join('|').concat("|0.00") || trade.units.map { |unit| "#{unit.item.product.category2.id rescue 0},#{sharing_options['description']},#{"%.2f" % (unit.discount*sharing_options['ratio'])},#{"%.2f" % unit.discount},1" }.join('|').concat("|#{"%.2f" % ((trade.units.map(&:discount).sum - trade.units.map(&:price).sum)*sharing_options['ratio'])}")),
        :p_info => trade.units && trade.units.map { |unit| "#{unit.item.product.category2.id rescue 0},#{unit.item.product.name.strip rescue ''},#{unit.item.product.id rescue 0},#{"%.2f" % unit.discount},1,#{[unit.item.product.category1.name.strip, unit.item.product.category2.name.strip].join('_') rescue ''},#{CGI::escape("http://#{::HOSTS['dynamic']}/#subapp=productGrid&popup=singleProduct&productId=#{unit.item.product.id}")}" }.join('|'),
        :server_price => "%.2f" % 0,
        :total_price => trade.units && "%.2f" % trade.units.map(&:price).sum,
        :coupon => trade.units && "%.2f" % (trade.units.map(&:discount).sum - trade.units.map(&:price).sum || 0),
        :status => {"pay" => 1, "audit" => 1, "ship" => 2, "receive" => 5, "complete" => 5, "cancel" => 6, "punished" => 6, "freezed" => 6, "return" => 6, "prepare" => 2}[trade.status],
      }
    end

    respond_to do |format|
      format.xml { render :text => @trades.compact.to_xml(:root => 'orders', :dasherize => false, :skip_types => true, :skip_nils => true).gsub(/&#\d{5};/) { |s| CGI::unescapeHTML(s) }, :layout => false }
    end
  end

  ##
  # == 360CPS系统对账查询
  #
  # === Request
  #
  # ==== Resource
  #
  # POST /shop/trades/mall360_reconciliation
  #
  # ==== Parameters
  #
  # bid :: 合作网站编号
  # bill_month :: 对账月份 yyyy-MM
  # last_order_id :: 上次查询返回的最后一个订单号
  # active_time :: 调用发起时间，精确到秒
  # sign :: 签名信息
  #
  # === Response
  #
  # ==== XML
  #   <orders>
  #     <order>
  #       <order_id>订单号</order_id>
  #       <order_updtime>订单最后更新时间</order_updtime>
  #       <order_time>下单时间</order_time>
  #       <server_price>服务费用</server_price>
  #       <total_price>订单应付总额</total_price>
  #       <coupon>用户使用优惠卡或积分抵充商品的金额</coupon>
  #       <total_comm>总佣金</total_comm>
  #       <commission>佣金明细 商品分类id,分成比例,分成金额,商品单价,数量|商品分类id,分成比例,分成金额,商品单价,数量|优惠券扣除佣金额</commission>
  #     </order>
  #   </orders>
  #
  def mall360_reconciliation
    config = OAUTH_CONFIG["mall360"]

    unless params[:sign] == Digest::MD5.hexdigest("#{params[:bid]}##{params[:active_time]}##{config["secret"]}")
      render :text => "签名验证失败", :layout => false
      return
    end

    bill_month = Date.strptime(params[:bill_month] || Time.new.strftime("%Y-%m"), "%Y-%m").to_time
    @trades = Shop::Trade.scoped(:limit => 200, :conditions => ["shop_trades.link_id IN (SELECT id FROM shop_links WHERE ad_id IN (SELECT id FROM shop_ads WHERE promotion_id = 132)) AND (shop_trades.status = 'receive' OR shop_trades.status = 'complete') AND (shop_trades.created_at >= ? AND shop_trades.created_at < ?) AND (shop_clicks.id IS NOT NULL)", bill_month, bill_month.months_since(1)], :order => "id ASC", :joins => "left join shop_clicks on shop_trades.click_id = shop_clicks.id AND shop_clicks.path REGEXP 'qihoo_id'", :select => "shop_trades.*, shop_clicks.path").scoped(:conditions => !params[:last_order_id].blank? && ["shop_trades.id > ?", params[:last_order_id]]).map do |trade|
      is_first_trade = trade == trade.user.trades.scoped(:conditions => "ship_at IS NOT NULL", :order => "created_at ASC").first
      sharing_options = trade.link_id == 300173 ? {'ratio' => 0.40, 'description' => '40%'} : {'ratio' => 0.10, 'description' => '10%'}
      cps_option = URI.decode(URI.parse(trade.click.path).query).scan(/([^=;&]+)=([^;&]*)/).map { |k, v| {k => v} }.inject({}, &:merge).symbolize_keys.slice(:qihoo_id, :qid, :ext) rescue {}

      {
        :order_id => trade.id,
        :order_time => trade.created_at && trade.created_at.to_s(:db),
        :order_updtime => trade.updated_at && trade.updated_at.to_s(:db),
        :total_comm => trade.units && "%.2f" % (is_first_trade && 500 || (trade.units.map(&:price).sum * sharing_options['ratio'])),
        :commission => trade.units && (is_first_trade && (trade.units.each_with_index.map { |unit, index| "#{unit.item.product.category2.id rescue 0},#{ index == 0 ? "F500,500.00," : "0%,0.00,"}#{"%.2f" % unit.discount},1" }).join('|').concat("|0.00") || trade.units.map { |unit| "#{unit.item.product.category2.id rescue 0},#{sharing_options['description']},#{"%.2f" % (unit.discount*sharing_options['ratio'])},#{"%.2f" % unit.discount},1" }.join('|').concat("|#{"%.2f" % ((trade.units.map(&:discount).sum - trade.units.map(&:price).sum)*sharing_options['ratio'])}")),
        :server_price => "%.2f" % 0,
        :total_price => trade.units && "%.2f" % trade.units.map(&:price).sum,
        :coupon => trade.units && "%.2f" % ((trade.units.map(&:discount).sum - trade.units.map(&:price).sum) || 0)
      }
    end

    respond_to do |format|
      format.xml { render :xml => @trades.compact.to_xml(:root => 'orders', :dasherize => false, :skip_types => true) }
    end
  end

  ##
  # == 商城有效购买次数
  #
  # === Request
  #
  # ==== Resource
  #
  # GET /shop/trades/mall_units_count
  #
  # ==== Parameters
  #
  # mall_id :: 商城ID
  # trade_start_at :: 订单查询开始时间
  #
  # === Response
  #
  # ==== JSON
  #
  #   {
  #     "count": count
  #   }
  #
  # ==== XML
  #
  # ==== YAML
  #
  def mall_units_count
    count = Shop::Unit.where('shop_units.returned' => false).where(['shop_units.created_at >= ?', (Time.parse(params[:trade_start_at]) rescue Time.now)]).joins(:trade).where('shop_trades.user_id' => @current_user.id).joins(item: :product).where('shop_products.mall_id' => params[:mall_id].to_i).count

    respond_to do |format|
      format.xml { @data = {count: count} }
    end
  end

  ##
  # == 登记德州扑克活动码
  #
  # === Request
  #
  # ==== Resource
  #
  # PUT /shop/trades/:id/texas_holdem_apply
  #
  # ==== Parameters
  #
  # id :: ID
  # \trade[texas_holdem_code] :: 德州扑克活动码
  #
  # === Response
  #
  # ==== JSON
  #
  #   {
  #     "trade": {
  #
  #     },
  #     "user": {
  #       "id": ID,
  #       "name": 姓名,
  #       "sex": 性别,
  #     }
  #   }
  #
  # ==== XML
  #
  # ==== YAML
  #
  def texas_holdem_apply
    @trade = Shop::Trade.acquire(params[:id])

    if @trade.user_id != @current_user.id || !%[pay audit].include?(@trade.status)
      not_authorized
      return
    end

    @trade.update_attributes!(texas_holdem_code: trade_params.try(:[], :texas_holdem_code))
    @user = Shop::User.find_by_texas_holdem_code trade_params.try(:[], :texas_holdem_code).to_s

    respond_to do |format|
      format.html
      format.xml { @data = {'trade' => @trade, 'user' => @user} }
    end
  end

  private

  def authorized?
    super
    return true if %w[checkout alipay_return alipay_wallet_return cmbchina_return bill99_return lakala_return ccb_return cmbc_return cart add_to_cart update_cart new unionpay_return pab_return mall360 mall360_reconciliation pgs_return boc_creditcard_return boc_return unionpay_wap_return comm_creditcard_return payment_success payment_failure cmbchina_creditcard_return wechat_return pab_pay_return icbc_return].include?(params[:action])
    return @current_user && @trade.user_id == @current_user.id || trade_params && @trade.checkout_token == trade_params[:checkout_token] if %w[show checkout update bill99_query alipay_query cmbchina_query lakala_query ccb_query unionpay_query cmbc_query pab_query pgs_query boc_creditcard_query boc_query unionpay_wap_query comm_creditcard_query cmbchina_creditcard_query wechat_query pab_pay_query icbc_query].include?(params[:action]) && (@trade = Shop::Trade.acquire(params[:id]))
    !!@current_user
  end

  def get_sign_bytes(str)
    return if (str.size % 2 == 1);
    i, bytes = 0, []
    while i < str.size
      bytes << [str[i..i+1].to_i(16)].pack('C').unpack('c').try(:first); i+=2
    end
    bytes
  end

  def yqf_send_data
    begin
      if @trade.tries(:link, :ad, :promtion_id) == 247
        units_data = []
        @trade.units.includes(:item).includes(item: :product).each do |unit|
          units_data << {
            productNo: unit.item_id,
            name: unit.item.product.name,
            amount: "1",
            price: unit.price,
            category: unit.item.category2.name,
            commissionType: ""}
        end
        land_params = Rack::Utils.parse_nested_query(URI(@trade.click.path).query)
        json_data = {orders:
                       [{
                          orderNo: @trade.id,
                          orderTime: @trade.created_at.strftime("%Y-%m-%d %H:%M:%S"),
                          updateTime: @trade.updated_at.strftime("%Y-%m-%d %H:%M:%S"),
                          campaignId: land_params["ihu_srcid"],
                          feedback: land_params["ihu_usrid"],
                          products: units_data,
                          orderStatus: "",
                          paymentStatus: "",
                          paymentType: "",
                          orderstatus: "",
                          encoding: "utf-8"
                        }]}
        url = url_for(subdomain: 'o', domain: 'yiqifa.com', controller: '/servlet', action: 'handleCpsInterIn', interId: YiQiFa["inter_id"], json: json_data.to_json)
        req = Mechanize.new.tap { |agent| agent.open_timeout = 1; agent.read_timeout = 1 }.get(url)
      end
    rescue => e
      logger.info "product_readings_count_error #{e.message}"
    end
  end

  def trade_params
    params.require(:trade) && params.require(:trade).permit!
  end
end
