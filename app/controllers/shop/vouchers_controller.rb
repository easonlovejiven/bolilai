##
# = 商城 代金券 界面
#
class Shop::VouchersController <  Shop::ApplicationController

	##
	# == 列表
	#
	# === Request
	#
	# ==== Resource
	#
	# GET /shop/vouchers
	#
	# ==== Parameters
	#
	# page :: 页数
	# per_page :: 每页个数
	#
	# === Response
	#
	# ==== XML
	#
	#   <?xml version="1.0" encoding="UTF-8"?>
	#   <response>
	#     <vouchers type="Array">
	#       <voucher type="Shop::Voucher">
	#         <id type="integer">ID</id>
	#         <user_id type="integer">用户ID</user_id>
	#         <event_id type="integer">券种ID</event_id>
	#         <trade_id type="integer">订单ID</trade_id>
	#         <identifier>编号</identifier>
	#         <obtained_at type="datetime">获得时间</obtained_at>
	#         <event type="Shop::Event">
	#           <id type="integer">券种ID</id>
	#           <name>名称</name>
	#           <amount type="integer">金额</amount>
	#           <limitation type="integer">限制</limitation>
	#           <description>描述</description>
	#           <started_at>开始时间</started_at>
	#           <ended_at>结束时间</ended_at>
	#         </event>
	#       </voucher>
	#     </vouchers>
	#   </response>
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
	def index
		@vouchers = @current_user.vouchers.active._where(params[:where])._order(params[:order] || { :obtained_at => 'DESC' }).page(params[:page]).per(params[:per_page] || 10)

		respond_to do |format|
			format.html
			format.xml { @data = { 'vouchers' => @vouchers } }
		end
	end

	##
	# == 更新
	#
	# === Request
	#
	# ==== Resource
	#
	# PUT /shop/vouchers/1
	#
	# ==== Parameters
	#
	# \voucher[identifier] :: 编号
	#
	# === Response
	#
	# ==== XML
	#
	#   <?xml version="1.0" encoding="UTF-8"?>
	#   <response>
	#     <voucher type="Shop::Voucher">
	#       <id type="integer">ID</id>
	#       <user_id type="integer">用户ID</user_id>
	#       <event_id type="integer">券种ID</event_id>
	#       <trade_id type="integer">订单ID</trade_id>
	#       <identifier>编号</identifier>
	#       <obtained_at type="datetime">获得时间</obtained_at>
	#       <event type="Shop::Event">
	#         <id type="integer">券种ID</id>
	#         <name>名称</name>
	#         <amount type="integer">金额</amount>
	#         <limitation type="integer">限制</limitation>
	#         <description>描述</description>
	#         <started_at>开始时间</started_at>
	#         <ended_at>结束时间</ended_at>
	#       </event>
	#     </voucher>
	#   </response>
	#
	# ==== JSON
	#
	#   {
	#     "voucher" : {
	#       "id" : ID,
	#       "user_id" : 用户ID,
	#       "event_id" : 券种ID,
	#       "trade_id" : 订单ID,
	#       "identifier" : 编号,
	#       "obtained_at" : 获得时间,
	#       "event" : {
	#         "id" : 券种ID,
	#         "name" : 名称,
	#         "amount" : 金额,
	#         "limitation" : 限制,
	#         "description" : 描述,
	#         "started_at" : 开始时间,
	#         "ended_at" : 结束时间,
	#       },
	#     },
	#   }
	#
	def update
		@voucher = Voucher.active.find_by_identifier(params[:voucher][:identifier])

		if @voucher.user_id
			not_authorized
			return
		end

		if @voucher.update_attributes(:user_id => @current_user.id, :obtained_at => Time.now)
			respond_to do |format|
				format.html { redirect_to shop_voucher_path(@voucher),:status => :ok }
				format.xml { @data = { 'voucher' => @voucher } }
			end
		else
			respond_to do |format|
				format.html { render :action => :new }
				format.xml { raise ActiveRecord::RecordInvalid.new(@voucher) }
			end
		end
	end

	##
	# == 兑换代金券
	#
	# === Request
	#
	# ==== Resource
	#
	# POST /shop/vouchers/exchange
	#
	# ==== Parameters
	#
	# \vouchers[][id] :: 代金券ID
	# \events[][id] :: 券种ID
	#
	# === Response
	#
	# ==== XML
	#
	#   <?xml version="1.0" encoding="UTF-8"?>
	#   <response>
	#     <vouchers type="Array">
	#       <voucher type="Shop::Voucher">
	#         <id type="integer">ID</id>
	#         <user_id type="integer">用户ID</user_id>
	#         <event_id type="integer">券种ID</event_id>
	#         <trade_id type="integer">订单ID</trade_id>
	#         <identifier>编号</identifier>
	#         <obtained_at type="datetime">获得时间</obtained_at>
	#         <event type="Shop::Event">
	#           <id type="integer">券种ID</id>
	#           <name>名称</name>
	#           <amount type="integer">金额</amount>
	#           <limitation type="integer">限制</limitation>
	#           <description>描述</description>
	#           <started_at>开始时间</started_at>
	#           <ended_at>结束时间</ended_at>
	#         </event>
	#       </voucher>
	#     </vouchers>
	#   </response>
	#
	# === JSON
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
	#
	def exchange
		@success = database_transaction do
			params[:vouchers] = params[:vouchers].values if params[:vouchers].is_a?(Hash)
			params[:events] = params[:events].values if params[:events].is_a?(Hash)
			@vouchers = params[:vouchers].map{|p| Voucher.find(p[:id]) }
			@events = params[:events].map{|p| Event.find(p[:id]) }
			@vouchers.each{|voucher| raise 'invalid voucher' unless voucher.active? && !voucher.trade && voucher.user_id == @current_user.id }
			(@events+@vouchers.map(&:event)).each{|event| raise 'invalid event' unless event && event.active? && event.published? && Time.now < event.ended_at }.inject{|a, b| raise 'invalid ratio' unless (a ||= b) && a.limitation*b.amount == a.amount*b.limitation && a.started_at == b.started_at && a.ended_at == b.ended_at; a }

			raise 'unequivalent amount' unless @vouchers.map(&:event).map(&:amount).inject(0, &:+) == @events.map(&:amount).inject(0, &:+)

			remark = "vouchers:#{@vouchers.map(&:id).join(',')}->events:#{@events.map(&:id).join(',')}"
			@vouchers.each{|voucher| voucher.update_attributes!(:active => false, :remark => "#{voucher.remark}\n\n\n#{remark}") }
			@new_vouchers = @events.map{|event| event.vouchers.create!(:user_id => @current_user.id, :obtained_at => Time.now, :remark => remark) }
		end

		if @success
			respond_to do |format|
				format.html { redirect_to params[:redirect] || shop_vouchers_path ,:status => :ok }
				format.xml { @data = { 'vouchers' => @new_vouchers } }
			end
		else
			respond_to do |format|
				format.html { redirect_to request.referer || shop_vouchers_path }
				format.xml { raise ArgumentError }
			end
		end
	end
end
