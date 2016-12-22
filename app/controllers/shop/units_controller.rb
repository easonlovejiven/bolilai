##
# = 商城 单位 界面
#
class Shop::UnitsController < Shop::ApplicationController

  ##
  # == 查看
  #
  # === Request
  #
  # ==== Resource
  #
  # GET /shop/trades/:trade_id/units/:id
  #
  # ==== Parameters
  #
  # trade_id :: 交易ID
  # id :: 单位ID
  #
  # === Response
  #
  # ==== XML
  #
  #   <?xml version="1.0" encoding="UTF-8"?>
  #   <response>
  #     <unit type="Shop::Unit">
  #       <id type="integer">单位ID</id>
  #       <circle_id type="integer">圈物ID</circle_id>
  #       <price type="integer">价格</price>
  #       <percent type="integer">折扣</percent>
  #       <point type="integer">折扣积分</point>
  #       <bonus type="integer">奖励积分</bonus>
  #       <discount type="integer">悦购价</discount>
  #       <contributed type="boolean">投稿</contributed>
  #       <returned type="boolean">退货</returned>
  #       <status>退货状态</status>
  #       <return_phone>退款电话</return_phone>
  #       <return_name>退款人</return_name>
  #       <return_bank>退款银行</return_bank>
  #       <return_account>退款帐号</return_account>
  #       <return_branch>退款支行</return_branch>
  #       <return_province>退款身份</return_province>
  #       <return_city>退款城市</return_city>
  #       <item type="Shop::Item">
  #         <id type="integer">单件ID</id>
  #         <identifer>编号</identifer>
  #         <measure>尺寸</measure>
  #         <product type="Shop::Product">
  #           <id type="integer">产品ID</id>
  #           <label>备注</label>
  #           <prefix>前缀</prefix>
  #           <name>名称</name>
  #           <description>描述</description>
  #           <major_pic>主图片</major_pic>
  #           <color_pic>颜色图片</color_pic>
  #           <color_name>颜色名称</color_name>
  #           <category2 type="Shop::Category">
  #             <id type="integer">分类ID</id>
  #             <name>名称</name>
  #           </category2>
  #         </product>
  #       </item>
  #     </unit>
  #   </response>
  #
  # ==== JSON
  #
  #   {
  #     "unit" : {
  #       "id" : 单位ID,
  #       "circle_id" : 圈物ID,
  #       "price" : 价格,
  #       "percent" : 折扣,
  #       "point" : 折扣积分,
  #       "bonus" : 奖励积分,
  #       "discount" : 悦购价,
  #       "contributed" : 投稿,
  #       "returned" : 退货,
  #       "status" : 退货状态,
  #       "return_phone" : 退款电话,
  #       "return_name" : 退款人,
  #       "return_bank" : 退款银行,
  #       "return_account" : 退款帐号,
  #       "return_branch" : 退款支行,
  #       "return_province" : 退款身份,
  #       "return_city" : 退款城市,
  #       "item" : {
  #         "id" : 单件ID,
  #         "identifer" : 编码,
  #         "measure" : 尺寸,
  #         "product" : {
  #           "id" : 产品ID,
  #           "label" : 备注,
  #           "prefix" : 前缀,
  #           "name" : 名称,
  #           "major_pic" : 主图片,
  #           "color_pic" : 颜色图片,
  #           "color_name" : 颜色名称,
  #           "category2" : {
  #             "id" : 分类ID,
  #             "name" : 名称,
  #           },
  #         },
  #       },
  #     },
  #   }
  #
  def show
    @unit = Shop::Unit.acquire(params[:id])

    if @unit.trade.user_id != @current_user.id
      not_authorized
      return
    end

    respond_to do |format|
      format.html
      format.xml { @data = {'unit' => @unit} }
    end

  end

  ##
  # == 单位投稿
  #
  # === Request
  #
  # ==== Resource
  #
  # PUT /shop/trades/:trade_id/units/:id/contribute
  #
  # ==== Parameters
  #
  # trade_id :: 交易ID
  # id :: 单位ID
  # circle_id :: 圈物id
  #
  # === Response
  #
  # 返回一条Shop::Trade
  #
  def contribute
    @unit = Shop::Unit.acquire(params[:id])

    if @unit.trade.user_id != @current_user.id || @unit.contributed? || @unit.trade.status != 'complete'
      not_authorized
      return
    end

    @success = database_transaction do
      @photo = Circle::Photo.acquire(params[:circle_id])
      @unit.update_attributes!(:contributed => true, :circle_id => @photo.id)
    end

    if @success
      respond_to do |format|
        format.html { redirect_to params[:redirect] || shop_trade_path(@unit.trade),status: :ok }
        format.xml { @data = {'trade' => @unit.trade} }
      end
    else
      respond_to do |format|
        format.html { redirect_to params[:redirect] || shop_trade_path(@unit.trade),status: :ok }
        format.xml { ActiveRecord::RecordInvalid.new(@unit.trade) }
      end
    end
  end

  ##
  # == 单位申请退货
  #
  # === Request
  #
  # ==== Resource
  #
  # PUT /shop/trades/:trade_id/units/:id/returning
  #
  # ==== Parameters
  #
  # trade_id :: 交易ID
  # id :: 单位ID
  # \unit[return_phone] :: 退款电话
  # \unit[return_province] :: 退款省份
  # \unit[return_city] :: 退款城市
  # \unit[return_bank] :: 退款银行
  # \unit[return_branch] :: 退款支行
  # \unit[return_name] :: 退款姓名
  # \unit[return_account] :: 退款帐号
  #
  # === Response
  #
  # 返回一条Shop::Trade
  #
  def returning
    @unit = Shop::Unit.acquire(params[:id])

    if @unit.trade.user_id != @current_user.id || !%w[audit ship receive complete].include?(@unit.trade.status) || @unit.trade.payment_service == 'express' && @unit.trade.status != 'complete' || @unit.status == 'complete'
      not_authorized
      return
    end

    @success = database_transaction do
      @unit.attributes = unit_params.slice(:return_phone, :return_province, :return_city, :return_bank, :return_branch, :return_name, :return_account)
      @unit.status = 'audit' if @unit.status.blank?
      @unit.request_at ||= Time.now
      @unit.save!
    end

    if @success
      respond_to do |format|
        format.html { redirect_to params[:redirect] || shop_trade_path(@unit.trade),status: :ok }
        format.xml { @data = {'trade' => @unit.trade} }
      end
    else
      respond_to do |format|
        format.html { redirect_to params[:redirect] || shop_trade_path(@unit.trade),status: :ok }
        format.xml { ActiveRecord::RecordInvalid.new(@unit.trade) }
      end
    end
  end

  private
  def unit_params
    params[:unit].permit [:return_phone, :return_province, :return_city, :return_bank, :return_branch, :return_name, :return_account]
  end
end
