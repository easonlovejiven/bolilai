##
# = 商城 交易 表
#
# == Fields
#
# original_id :: 原始交易ID
# user_id :: 用户ID
# item_id :: 单件ID
# contact_id :: 地址ID
# link_id :: 链接ID
# click_id :: 点击ID
# status :: 状态，必须为{ 'pay' => '待付款', 'audit' => '待审核', 'ship' => '待发货', 'receive' => '待收货', 'complete' => '完成', 'cancel' => '取消', 'punished' => '惩罚', 'freezed' => '冻结', 'prepare' => '备货中', 'contribute' => '待投稿', 'accept' => '接受', 'reject' => '拒绝', 'return' => '返还' }
# price :: 价格
# payment_price :: 付款价格
# comment :: 留言
# identifier :: 编号
# point :: 积分
# percent :: 折扣
# note_id :: 投稿ID
# circle_id :: 投稿ID
# bonus :: 奖励积分
# punishment :: 惩罚积分
# payment_service :: 付款服务，必须为{ 'alipay' => '支付宝', 'giveaway' => '赠送' , 'express' => '货到付款' , 'cmbchina' => '招商银行' , 'icbc' => '工商银行' }
# payment_identifier :: 付款标识
# delivery_service :: 快递服务，必须为{ 'fedex' => '联邦快递', 'zjs' => '宅急送', 'ems' => '邮政EMS', 'offline' => '线下', 'pickup' => '自取', 'sf' => '顺丰速运' }之一
# delivery_identifier :: 快递编号
# delivery_time :: 快递时间，必须为{ 'workday' => '工作日', 'playday' => '休息日', 'all' => '皆可' }之一
# invoice_type :: 发票类型，必须为{ 'personal' => '个人', 'company' => '公司' }之一
# invoice_title :: 发票抬头
# invoice_content :: 发票内容，必须为{ 'present' => '礼品', 'detail' => '商品明细' }之一
# editor_id :: 编辑ID
# client :: 客户端类型, 必须为 %w[manage html5 osx windows linux flash iphone ipad android phone_web ipad_web wechat] 之一
# audit_editor_id :: 审核编辑ID
# audit_at :: 审核时间
# prepare_editor_id :: 备货编辑ID
# prepare_at :: 备货时间
# ship_editor_id :: 发货编辑ID
# ship_at :: 发货时间
# freeze_editor_id :: 冻结编辑ID
# freeze_at :: 冻结时间
# receipt_editor_id :: 收款编辑ID
# receipted_at :: 收款时间
# receipted? :: 收款？
# delivery_received_at :: 快递收货时间
# invoice_delivery_service :: 发票快递服务，取值同“快递服务”
# invoice_delivery_identifier :: 发票快递编号
# invoice_remark :: 发票备注
# package_from :: 包装发送人
# package_to :: 包装接收人
# package_content :: 包装内容
# whisper_style :: 密语风格
# whisper_from :: 密语发送人
# whisper_to :: 密语接收人
# whisper_content :: 密语内容
# remark :: 备注
# texas_holdem_code :: 德州扑克活动码
# shop_id :: 店铺ID
# shop_identifier :: 商场单号
# guide_id :: 导购ID
# active? :: 有效？
#
# == Indexes
#
class Shop::Trade < ActiveRecord::Base
  self.table_name = "shop_trades"
  include ::PayApi::Api
  include ::Delivery::Api
  belongs_to :original, :class_name => "Shop::Trade"
  belongs_to :user, :class_name => "Shop::User"
  belongs_to :editor, class_name: Manage::User, foreign_key: "editor_id"
  belongs_to :audit_editor, class_name: Manage::User, foreign_key: "audit_editor_id"
  belongs_to :prepare_editor, class_name: Manage::User, foreign_key: "prepare_editor_id"
  belongs_to :ship_editor, class_name: Manage::User, foreign_key: "ship_editor_id"
  belongs_to :freeze_editor, class_name: Manage::User, foreign_key: "freeze_editor_id"
  belongs_to :receipt_editor, class_name: Manage::User, foreign_key: "receipt_editor_id"
  belongs_to :contact, class_name: Shop::Contact
  belongs_to :invoice_contact, class_name: Shop::Contact, foreign_key: 'invoice_contact_id'
  belongs_to :link
  belongs_to :click
  belongs_to :latest_link, class_name: 'Shop::Link', foreign_key: 'latest_link_id'
  belongs_to :latest_click, class_name: 'Shop::Click', foreign_key: 'latest_click_id'
  has_one :good
  has_one :ticket
  has_many :units, :class_name => "Shop::Unit"
  # has_many :updatings, :class_name => "Shop::TradesUpdating"
  has_many :calls
  # has_many :smss, :class_name => "Shop::Sms", :conditions => { :active => true }
  # belongs_to :shop, class_name: Retail::Shop
  # belongs_to :guide, class_name: Retail::Guide
  # belongs_to :mall_promotion, class_name: Retail::MallPromotion

  accepts_nested_attributes_for :contact
  accepts_nested_attributes_for :invoice_contact
  #
  validates_associated :contact, allow_blank: true
  validates_associated :invoice_contact, allow_blank: true

  attr_accessor :need_delivery, :need_invoice

  scope :active, -> { where(active: true) }

  def self.create_fields;
    %w[delivery_service delivery_time delivery_phone invoice_type invoice_title invoice_content comment contact user_id contact_id invoice_contact_id package_from package_to package_content whisper_style whisper_from whisper_to whisper_content is_present is_present shop_id shop_identifier guide_id remark mall_promotion_id need_delivery need_invoice];
  end

  STATUS = {
    "pay" => '待付款',
    "audit" => '待审核',
    "ship" => '待发货',
    "receive" => '待收货',
    "contribute" => '待投稿',
    "complete" => '完成',
    "cancel" => '取消',
    "accept" => '接受',
    "reject" => '拒绝',
    "punished" => '过期',
    "freezed" => '冻结',
    "return" => '返还',
    "prepare" => '出库中',
  }


  DELIVERY_TIMES = {'workday' => '仅工作日', 'playday' => '仅休息日', 'all' => '所有日期皆可'}
  INVOICE_TYPES = {'personal' => '个人', 'company' => '公司'}
  INVOICE_CONTENTS = {'present' => '礼品', 'detail' => '明细'}

  CLIENTS = %w[manage html5 osx windows linux flash iphone ipad android phone_web ipad_web wechat]

  # validates :shop_identifier, presence: true, if: -> { shop }
  # validates :mall_promotion, existence: true, if: -> { shop }
  # validates :status, inclusion: STATUS.keys, allow_blank: true
  # validates :delivery_service, inclusion: delivery_coms_arr.map { |service| service[:name] }, allow_blank: true
  # validates :payment_service, inclusion: PAYMENT_SERVICES.keys, allow_blank: true
  # validates :delivery_time, inclusion: DELIVERY_TIMES.keys, allow_blank: true
  # validates :invoice_type, inclusion: INVOICE_TYPES.keys, allow_blank: true
  # validates :invoice_content, inclusion: INVOICE_CONTENTS.keys, allow_blank: true
  # validates :client, inclusion: CLIENTS, allow_blank: true

  %w[status delivery_service payment_service delivery_time invoice_type invoice_content client].each do |field|
    define_method "#{field}_" do
      I18n.t("activerecord.enums.#{self.class.name.downcase.gsub('::', '/')}.#{field}.#{self.send(field)}")
    end
  end


  def freezable? # :nodoc: all
    self.status == 'pay' || (self.payment_service.in?(%w[express shop]) || self.payment_service.nil?) && %w[pay audit prepare ship receive].include?(self.status)
  end

  def freeze!(options = {})
    options = RecursiveOpenStruct.new(options, recurse_over_arrays: true)
    @from.update_attributes!(status: 'freezed', freeze_editor_id: options.freeze_editor_id, freeze_at: Time.now)
    # @from.updated!(status: @from.status)
    @from.units.each(&:returnit!)
    @from.close_payment
  end

  def calculate_product_hourglass! # :nodoc: all
    self.units.map { |unit| unit.item.product }.uniq.map { |product| product.update_attributes!(:hourglass_pause_duration => (product.hourglass_pause_duration || 0) + (Time.now - self.created_at) / 1.minute) if product.hourglass_started_at }
  end

  def try_punish! # :nodoc: all
    return unless self.status == 'pay' && self.created_at < 2.hours.ago

    ActiveRecord::Base.transaction do
      punishment = 0
      self.units.each(&:returnit!)
      self.update_attributes!(:status => 'punished', :punishment => punishment)
      # self.updated!(:status => self.status)
      # self.ticket.update_attributes!(:trade_id => nil, :user_id => nil) if self.ticket
      # self.calculate_product_hourglass!
      Core::User.acquire(self.user_id).do_transaction!(-punishment, "订单过期，交易ID=#{self.id}")
      self.close_payment
    end
  end


  def audit!(options = {}) # :nodoc: all
    return unless self.status == 'pay'

    ActiveRecord::Base.transaction do
      self.update_attributes!(options.slice(:payment_service, :payment_identifier, :payment_return).merge(:status => 'audit'))
      # self.updated!(:status => self.status)
    end

    if options[:payment_service] == 'express'
      # Core::Mailer.mail(
      # 	:recipients => "info@barlar.cn",
      # 	:subject => "订单#{self.identifier}申请货到付款 #{HOSTS['dynamic']}",
      # 	:template => 'auction_express_pay_manage',
      # 	:body => { :trade => self }
      # )
    else
      Core::Mailer.mail(
        :recipients => @account.email,
        :subject => "您的订单#{self.identifier}已成功付款",
        :template => 'shop_pay',
        :body => {:trade => self}
      ) if (@account = Core::Account.find(self.user)) && @account.user.setting.receive_promotion_email?
    end

    # self.close_payment
  end


  class << self
    def send_shipped
      Mechanize.new.post("http://nm.weimall.com/messages.json", user_ids: self.user_id, category_id: 2, content: "亲爱的用户，您的订单已经通过#{delivery_coms_arr.detect { |p| p[:name] == self.delivery_service }[:title]}发货，运单号#{self.delivery_identifier}。请您注意查收。", deeplink: 'subapp=my&channel=buyManage&status=receive')
      Mechanize.new.post("http://wx.weimall.com/trade/#{self.id}/send_notice") if self.delivery_service.present?
    rescue => e
      logger.error %[#{e.class.to_s}: #{e.message}\n#{e.backtrace.map { |s| "\tfrom #{s}\n" }.join}]
    end


    def sale_out!
      agent = Mechanize.new
      agent.user_agent_alias = 'Mac Safari'
      login = agent.get("http://#{OAUTH_CONFIG['erp']['site']}/user/login").forms.first
      login['inc'] = '30:广州富玥珠宝有限公司'
      login['user_name'] = OAUTH_CONFIG['erp']['username']
      login['password'] = OAUTH_CONFIG['erp']['password']
      login.click_button

      erp_crstorage = ErpRecord.connection.select_all("SELECT eg.id, eg.name, eg.pid, eg.status, ec.storage_id, ec.storage_name FROM erp_exorders_good AS eg LEFT JOIN erp_crstorage AS ec ON ec.sn = eg.pid WHERE eg.excforder_id = (SELECT id FROM erp_excforder WHERE trade_id = #{self.id})")
      erp_crstorage.each do |ec|
        saleout_page = agent.get('/saleout/add').forms.first
        saleout_id = saleout_page.action.split("/").last
        saleout = ErpRecord.connection.select_one("SELECT saleout_num FROM erp_saleout WHERE id = #{saleout_id}")
        erp_excforder = ErpRecord.connection.select_one("SELECT id, trade_id FROM erp_excforder WHERE trade_id = #{self.id}")
        sale_id = erp_excforder['id']
        info = agent.get("/saleout/infoiframe/saleout_id/#{saleout_id}/sale_id/#{sale_id}").forms.first
        checkgoods = agent.get("/saleout/checkgoods/good_id/#{ec['id']}/storage_id/#{ec['storage_id']}/pid/#{ec['pid']}/saleout_id/#{saleout_id}/saleout_num/#{saleout['saleout_num']}/trade_id/#{erp_excforder['trade_id']}/sale_id/#{erp_excforder['id']}/attn/#{info['attn']}")
        url = checkgoods.search('table input').first.attributes['onclick'].value.match(/\/.*\d+/).to_s
        agent.get("/saleout/ok.out" + url)
      end
    end

    class<<self

      def xml_options
        {:only => [:id, :status, :comment, :price, :payment_price, :created_at, :updated_at, :identifier, :punishment, :payment_service, :payment_identifier, :delivery_service, :delivery_identifier, :delivery_time, :delivery_phone, :invoice_type, :invoice_title, :invoice_content, :invoice_delivery_service, :invoice_delivery_identifier, :checkout_token, :checkout_name, :checkout_comment, :package_from, :package_to, :package_content, :whisper_style, :whisper_from, :whisper_to, :whisper_content, :is_present].freeze,
         :include => {
           :contact => {:only => [:id, :name, :country, :province, :city, :town, :address, :postcode, :phone, :mobile].freeze, }.freeze,
           :invoice_contact => {:only => [:id, :name, :country, :province, :city, :town, :address, :postcode, :phone, :mobile].freeze, }.freeze,
           :units => {
             :only => [:id, :circle_id, :price, :percent, :point, :bonus, :discount, :contributed, :returned, :status, :return_phone, :return_name, :return_bank, :return_account, :return_branch, :return_province, :return_city].freeze,
             :include => {
               :item => {
                 :only => [:id, :identifier, :measure].freeze,
                 :include => {
                   :product => {
                     :only => [:id, :label, :prefix, :name, :major_pic, :color_pic, :color_name, :hourglass_pause_duration, :hourglass_rate, :hourglass_started_at, :hourglass_trade_created_at, :hourglass_trade_price].freeze,
                     :include => {
                       :category2 => {:only => [:id, :name]}.freeze,
                       :brand => {:only => [:id, :name]}.freeze,
                     }.freeze,
                   }.freeze,
                 }.freeze,
               }.freeze,
               :voucher => {
                 :only => [:id, :event_id, :user_id, :trade_id, :identifier, :obtained_at].freeze,
                 :include => {
                   :event => {
                     :only => [:id, :name, :description, :amount, :limitation, :started_at, :ended_at].freeze,
                   }.freeze,
                 }.freeze,
               }.freeze,
               multibuy: {only: [:id, :name]},
             }.freeze,
           }.freeze,
         }.freeze,
        }
      end

      def others_to_pay_xml_options
        cattr_accessor :others_to_pay_xml_options
        {:only => [:id, :status, :price, :identifier, :checkout_token, :checkout_name, :checkout_comment, :delivery_phone, :created_at, :payment_service].freeze,
         :include => {
           :user => {
             :only => [:name].freeze,
           }.freeze,
           :units => {
             :only => [:price].freeze,
             :include => {
               :item => {
                 :include => {
                   :product => {
                     :only => [:name].freeze,
                   }.freeze,
                 }.freeze,
               }.freeze,
             }.freeze,
           }.freeze,
         }.freeze,
        }
      end


      def effective
        where("status not in  ('pay','cancel','reject','punished','freezed')")
      end
    end

  end
end
