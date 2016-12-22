##
# = 商城 用户 表
#
# == Fields
#
# editor_id :: 编辑ID
# name :: 名称
# sex :: 性别
# birthday :: 生日
# id_number :: 身份证号
# card_number :: 卡号
# service_editor_id :: 客服编辑ID
# label :: 标签
# trades_amount :: 交易总额
# trades_amount_calculated_at :: 交易总额计算时间
# suggested_level_id :: 建议等级ID
# level_id :: 等级ID，默认为1
# level_modified_at :: 等级修改时间
# percent :: 折扣
# mall_ids :: 商城ID列表
# remark :: 备注
# balance :: 余额
# crypted_password :: 加密密码
# customer_id :: 主要顾客ID
# texas_holdem_code :: 德州扑克活动码
#
# == Indexes
#
class Shop::User < ActiveRecord::Base
  self.table_name="shop_users"
  mount_uploader :pic_key, AvatarUploader, :mount_on => :pic

  belongs_to :account, class_name: Core::Account, foreign_key: 'id'
  belongs_to :level
  belongs_to :suggested_level, :class_name => "Shop::Level"
  belongs_to :editor, :foreign_key => 'editor_id', :class_name => "Manage::Editor"
  has_one :role_editor, :foreign_key => 'id', :class_name => "Manage::Editor"
  belongs_to :service_editor, :class_name => "Manage::Editor"
  has_one :operator, :foreign_key => 'person_id'
  has_many :trades
  has_many :contacts
  has_many :notifications
  has_many :bidders
  has_many :goods
  has_many :chances
  has_many :vouchers
  # has_many :preferences, :conditions => { :active => true }
  # has_many :costumers, :conditions => { :active => true }
  # has_many :fanships
  has_many :favorites
  has_many :hits
  has_many :updatings, :class_name => "Shop::UsersUpdating"
  # has_many :cards, :conditions => { :active => true }
  has_many :transactions
  belongs_to :customer, :class_name => "Shop::Costumer"
  # belongs_to :guide, class_name: Retail::Guide, foreign_key: 'id'

  validates :texas_holdem_code, :uniqueness => true, :allow_nil => true

  self.xml_options = {
      :only => [:id, :name, :sex].freeze,
  }

  def malls #:nodoc: all
    self.mall_ids.to_s.scan(/\d+/).map { |id| Mall.active.find_by_id(id) }.compact
  end

  def find_lottery_chances(lottery_id) #:nodoc: all
    Shop::Chance.scoped(:conditions => ["user_id = #{id} and lottery_id = ?", lottery_id])
  end

  def find_lottery_is_success(lottery_id, ticket_id) #:nodoc: all
    Shop::Chance.scoped(:conditions => ["user_id = #{id} and lottery_id = ? and ticket_id = ?", lottery_id, ticket_id])
  end

  def friends_in_one_good(good) #:nodoc: all
    Shop::Bidder.scoped(:conditions => ["user_id IN (#{friend_ids.blank? ? '("")' : friend_ids}) AND good_id = ?", good.id])
  end

  def lastest_bidding_point_in_one_good(good) #:nodoc: all
    x = bidders.scoped(:conditions => ["good_id = ?", good.id], :order => "current_point DESC")[0]
    x ? x.current_point : 0
  end

  def find_notifications(product, measure) #:nodoc: all
    notification = Shop::Notification.active
    notification = notification.scoped(:conditions => ["measure = ?", measure]) if !measure.blank?
    notification = notification.scoped(:conditions => ["product_id = ?", product.id])
    notification
  end

  def self.acquire(id) #:nodoc: all
    record = self.find_by_id(id)
    if !record || record.updated_at < 5.minutes.ago
      u = Core::User.find_by_id(id)
      # logger.info "\n\n\n\n#{id}\n\n\n#{u}\n\n"
      (record = self.new; record.id = u.id) unless record
      record.name = u.name
      record.sex = u.sex
      record.pic = u.pic
      # record.friend_ids = u.friend_ids.join(',')
      record.login_at = Time.now
      record.save
    end
    record
  end

  def can?(action, resource) #:nodoc: all
    @user ||= Manage::User.acquire(self.id)
    resource = "manage_#{resource}" if resource == "editor"
    resource = "auction_#{resource}" if (@role ||= Manage::Role.new) && @role.respond_to?("#{action}_auction_#{resource}?")
    @user.can?(action, resource)
  end

  def method_missing_with_privilege(method, *args) #:nodoc: all
    if m = method.to_s.match(/^can_([^\_]+)_([^\?]+)\??/)
      return self.can?(m[1], m[2])
    end

    method_missing_without_privilege(method, *args)
  end

  alias_method_chain :method_missing, :privilege

  attr_accessor :level_keep

  def update_trades_point_and_level_modified_at #:nodoc: all
    # was_level = self.level_id_was.blank? ? 0 : Shop::Level.find(self.level_id_was).limitation
    now_level = self.level_id.blank? ? 0 : self.level.limitation
    keep_level = self.level_id.blank? ? 0 : self.level.reservation
    # trades_point = self.trades_point.to_i - (self.level_keep == '1' ? keep_level : now_level > was_level ? now_level - was_level : 0)
    self.trades_point = trades_point
    self.level_modified_at = Time.now
  end

  def has_password
    !!crypted_password
  end

  def cards_balance
    self.cards.published.scoped(:conditions => ["started_at < ? AND ended_at > ?", Time.now, Time.now]).sum(:balance)
  end
end
