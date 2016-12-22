##
# = 商城 单位 表
#
# == Fields
#
# trade_id :: 交易ID
# item_id :: 单件ID
# circle_id :: 圈物ID
# multibuy_id :: 连拍ID
# discount :: 悦购价
# price :: 最终价格
# percent :: 折扣
# level_percent :: 用户等级折扣
# guide_percent :: 店铺折扣
# point :: 积分
# bonus :: 奖励积分
# contributed? :: 投稿？
# returned? :: 退货？
# status :: 状态，必须为{ '' => '未申请', 'audit' => '待审核', 'receive' => '待收货', 'complete' => '完成', 'cancel' => '取消', 'freezed' => '冻结', 'transfer' => '待退款', }之一
# request_at :: 请求时间
# audit_editor_id :: 审核编辑
# audit_at :: 审核时间
# receive_editor_id :: 收货编辑
# receive_at :: 收货时间
# transfer_editor_id :: 退款编辑
# transfer_at :: 退款时间
# freeze_editor_id :: 冻结编辑
# freeze_at :: 冻结时间
# return_phone :: 退款电话
# return_province :: 退款省份
# return_city :: 退款城市
# return_bank :: 退款银行
# return_branch :: 退款支行
# return_name :: 退款人
# return_account :: 退款帐号
# return_reason :: 退货原因
# amount_received :: 收款金额
# amount_received_at :: 收款时间
# amount_receive_editor_id :: 收款编辑
# amount_returned :: 现金退款金额
# amount_balance_returned :: 余额退款金额
# amount_returned_at :: 退款时间
# amount_return_editor_id :: 退款编辑
# remark :: 退货备注
# prepared? :: 已备货？
# prepare_remark :: 备货备注
#
# == Indexes
#
# trade_id
#
class Shop::Unit < ActiveRecord::Base
  self.table_name= :shop_units

  belongs_to :trade
  belongs_to :item
  belongs_to :voucher
  belongs_to :multibuy
  belongs_to :circle, :class_name => "Circle::Photo"
  belongs_to :request_editor, :class_name => "Manage::Editor"
  belongs_to :audit_editor, :class_name => "Manage::Editor"
  belongs_to :receive_editor, :class_name => "Manage::Editor"
  belongs_to :transfer_editor, :class_name => "Manage::Editor"
  belongs_to :freeze_editor, :class_name => "Manage::Editor"
  belongs_to :amount_receive_editor, :class_name => "Manage::Editor"
  belongs_to :amount_return_editor, :class_name => "Manage::Editor"

  attr_accessor :product_id, :measure, :quantity

  validate do |unit|
    other_units = trade.units.where("id != ?", unit.id)
    balance_payment_price = trade.price.to_i - trade.payment_price.to_i
    if (unit.amount_returned.to_i + unit.amount_balance_returned.to_i) > unit.price
      errors.add(:total_amount_returned, '退款总额不能超过商品单价')
    elsif other_units.sum(:amount_returned).to_i+unit.amount_returned.to_i > trade.payment_price.to_i
      errors.add(:amount_returned, '现金退款不能超过总现金支付')
    elsif other_units.sum(:amount_balance_returned).to_i+unit.amount_balance_returned.to_i > balance_payment_price
      errors.add(:amount_balance_returned, '余额退款不能超过总余额支付')
    end
  end

  STATUS = {
      'null' => '未申请',
      'audit' => '待审核',
      'receive' => '待收货',
      'complete' => '完成',
      'cancel' => '取消',
      'freezed' => '冻结',
      'transfer' => '待退款',
  }

  validates_inclusion_of :status, :in => STATUS.keys, :allow_blank => true

  RETURN_REASONS = [
      ["1、不喜欢", %w[不喜欢]],
      ["2、尺码问题", %w[尺码问题]],
      ["3、图片与实物不符", %w[图片与实物不符]],
      ["4、描述与实物不符", %w[描述与实物不符]],
      ["5、质量问题", %w[做工不好 包装物不齐]],
      ["6、物流问题", %w[快递超区 延时 服务差 运输残损 丢失]],
      ["7、其他问题", %w[临时出差 送人买重了]],
  ]

  FIELDS = [
      {
          :name => nil,
          :title => "",
          :value => [
              {:name => "退货ID", :value => :id},
              {:name => "交易ID", :value => :trade_id},
              {:name => "单件商品名称", :value => lambda { |u| u.item.product.name }, :permission => lambda(&:can_show_product?)},
              {:name => "退款电话", :value => :return_phone},
              {:name => "退款省份", :value => :return_province},
              {:name => "退款城市", :value => :return_city},
              {:name => "退款银行", :value => :return_bank},
              {:name => "退款支行", :value => :return_branch},
              {:name => "退款人", :value => :return_name},
              {:name => "退款帐号", :value => :return_account},
              {:name => "申请时间", :value => :request_at},
              {:name => "审核时间", :value => :audit_at},
              {:name => "收货时间", :value => :receive_at},
              {:name => "退款时间", :value => :transfer_at},
              {:name => "审核编辑", :value => lambda { |u| u.audit_editor && u.audit_editor.name }},
              {:name => "退货原因", :value => :return_reason},
              {:name => "退货备注", :value => :remark},
          ]
      },

      {
          :name => "apply",
          :title => "退款申请",
          :value => [
              {:name => "交易ID", :value => :trade_id},
              {:name => "交易创建时间", :value => lambda { |u| u.trade && u.trade.created_at(&:to_s) }},
              {:name => "交易地址姓名", :value => lambda { |u| u.trade && u.trade.contact && u.trade.contact.name }},
              {:name => "交易编号", :value => lambda { |u| u.trade && u.trade.identifier }},
              {:name => "商品信息", :value => lambda { |u| u.item && [u.item.identifer, u.item.product && u.item.product.name].join("\n") }},
              {:name => "付款服务", :value => lambda { |u| u.trade && Shop::Trade::PAYMENT_SERVICES[u.trade.payment_service] }},
              {:name => "退款金额", :value => :price},
              {:name => "退货原因", :value => :return_reason},
              {:name => "退货备注", :value => :remark},
              {:name => "代金券", :value => lambda { |u| u.voucher && u.voucher.event && u.voucher.event.name }},
              {:name => "退款账号", :value => :return_account},
              {:name => "退款姓名", :value => :return_name},
              {:name => "退款银行信息", :value => lambda { |u| "#{u.return_bank} #{u.return_branch}" }},
              {:name => "退款省份", :value => :return_province},
              {:name => "退款城市", :value => :return_city}
          ]
      }
  ]

  def returnit!(options = {}) #:nodoc: all
    return if self.returned?
    self.update_attributes!(options.merge(:returned => true))
    self.item.update_attributes!(:trade_id => nil)
    self.item.product.sync_sell_data!
    user = Core::User.where(id: self.trade.user_id).first
    if user.present?
      user.do_transaction!(self.point, "订单ID=#{self.trade.id} 退货ID=#{self.id} 返还抵折扣积分") if self.point && self.point > 0
      if self.core_point_added?
        self.update_attributes!(:core_point_subtracted => true)
        user.do_transaction!(-self.bonus, "投稿扣除，unit_id=#{self.id}")
      end
      if self.shop_point_added?
        self.update_attributes!(:shop_point_subtracted => true)
        shop_user = self.trade.user
        shop_user.update_attributes!(:trades_point => shop_user.trades_point.to_i - self.price)
        shop_user.updatings.create!(:trades_point => shop_user.trades_point)
      end
    end
    self.voucher.update_attributes!(:trade_id => nil) if self.voucher
  end
end
